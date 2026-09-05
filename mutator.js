// mutator.js — MIDI Mutator v1 engine
// Runs inside a [v8] object in a Max for Live MIDI Effect (Live 12 / Max 8.6+).
//
// What it does:
//   1. Reads the song's global key (root_note + scale_name) from the Live API.
//   2. Reads the currently selected Session clip's notes.
//   3. Generates N mutated copies of the clip into the next empty clip slots
//      on the same track. Mutations are constrained to the song's scale.
//
// Mutation model (per variation, driven by a seeded RNG so results are
// reproducible when Seed > 0):
//   - "Amount" % of notes are eligible for mutation; the rest pass through
//     untouched — this is what keeps the character of the original riff.
//   - Eligible notes: pitch drifts up/down by 1..Drift scale degrees, with a
//     small velocity humanize; optionally nudged by a 16th (Timing %).
//   - Delete % of eligible notes are removed (never below 40% of the original
//     note count, so a variation can't collapse to nothing).
//   - Add % new notes are cloned from existing notes and displaced in time
//     and pitch — additions are derived from the source material, not random.

autowatch = 1;

var GRID = 0.25; // one 16th note, in beats — grid for nudges and added notes

// ---------------------------------------------------------------------------
// Parameters — set from the device UI via [prepend <name>] → [v8]
// Defaults here must match the dials' initial values in the patch.
// ---------------------------------------------------------------------------
var params = {
  amount: 50,     // % of notes eligible for mutation
  drift: 2,       // max pitch move, in scale degrees
  delprob: 10,    // % chance an eligible note is deleted
  addprob: 10,    // new notes added, as % of original note count
  timing: 0,      // % chance an eligible note is nudged by one 16th
  variations: 4,  // how many variation clips to write per Mutate press
  seed: 0         // 0 = fresh random seed every press
};

function amount(v)     { params.amount = clamp(v, 0, 100); }
function drift(v)      { params.drift = clamp(Math.round(v), 1, 7); }
function delprob(v)    { params.delprob = clamp(v, 0, 100); }
function addprob(v)    { params.addprob = clamp(v, 0, 100); }
function timing(v)     { params.timing = clamp(v, 0, 100); }
function variations(v) { params.variations = clamp(Math.round(v), 1, 16); }
function seed(v)       { params.seed = Math.max(0, Math.round(v)); }

// ---------------------------------------------------------------------------
// Scales — pitch-class intervals for Live 12's common scale names.
// Unknown scale names fall back to chromatic so mutation never hard-fails.
// ---------------------------------------------------------------------------
var SCALES = {
  "Major":             [0, 2, 4, 5, 7, 9, 11],
  "Minor":             [0, 2, 3, 5, 7, 8, 10],
  "Dorian":            [0, 2, 3, 5, 7, 9, 10],
  "Mixolydian":        [0, 2, 4, 5, 7, 9, 10],
  "Lydian":            [0, 2, 4, 6, 7, 9, 11],
  "Phrygian":          [0, 1, 3, 5, 7, 8, 10],
  "Locrian":           [0, 1, 3, 5, 6, 8, 10],
  "Whole Tone":        [0, 2, 4, 6, 8, 10],
  "Minor Blues":       [0, 3, 5, 6, 7, 10],
  "Minor Pentatonic":  [0, 3, 5, 7, 10],
  "Major Pentatonic":  [0, 2, 4, 7, 9],
  "Harmonic Minor":    [0, 2, 3, 5, 7, 8, 11],
  "Melodic Minor":     [0, 2, 3, 5, 7, 9, 11],
  "Phrygian Dominant": [0, 1, 4, 5, 7, 8, 10],
  "Hungarian Minor":   [0, 2, 3, 6, 7, 8, 11]
};
var CHROMATIC = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

var NOTE_NAMES = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"];

// ---------------------------------------------------------------------------
// Entry points
// ---------------------------------------------------------------------------
function bang() { mutate(); }

function mutate() {
  var clip = new LiveAPI("live_set view detail_clip");
  if (!clip || Number(clip.id) === 0) {
    post("MIDI Mutator: no clip selected — double-click a Session MIDI clip first.\n");
    return;
  }

  // Path looks like "live_set tracks 3 clip_slots 2 clip" for Session clips.
  var path = clip.unquotedpath;
  var m = path.match(/live_set tracks (\d+) clip_slots (\d+) clip/);
  if (!m) {
    post("MIDI Mutator: Arrangement clips aren't supported yet — use a Session clip.\n");
    return;
  }
  var trackIdx = parseInt(m[1], 10);
  var slotIdx = parseInt(m[2], 10);

  // --- global key ---
  var song = new LiveAPI("live_set");
  var root = num(song.get("root_note"));
  var scaleName = str(song.get("scale_name"));
  var intervals = SCALES[scaleName] || CHROMATIC;
  var allowed = allowedPitches(root, intervals);

  // --- source notes ---
  var length = num(clip.get("length"));
  var raw = clip.call("get_notes_extended", 0, 128, 0, length);
  var notes = JSON.parse(raw).notes;
  if (!notes || notes.length < 2) {
    post("MIDI Mutator: clip needs at least 2 notes.\n");
    return;
  }
  var name = str(clip.get("name")) || "Clip";

  // --- write variations into the next empty slots on this track ---
  var track = new LiveAPI("live_set tracks " + trackIdx);
  var nSlots = track.getcount("clip_slots");
  var baseSeed = params.seed > 0 ? params.seed : Math.floor(Math.random() * 100000);

  var written = 0;
  var scan = slotIdx + 1;
  for (var v = 0; v < params.variations; v++) {
    var slot = null;
    while (scan < nSlots) {
      var s = new LiveAPI("live_set tracks " + trackIdx + " clip_slots " + scan);
      scan++;
      if (num(s.get("has_clip")) === 0) { slot = s; break; }
    }
    if (!slot) {
      post("MIDI Mutator: ran out of empty slots after " + written + " variation(s) — add scenes and press Mutate again.\n");
      break;
    }

    var rng = mulberry32(baseSeed + v * 7919);
    var mutated = mutateNotes(notes, length, allowed, rng);

    slot.call("create_clip", length);
    var newClip = new LiveAPI(slot.unquotedpath + " clip");
    addNotes(newClip, mutated);
    newClip.set("name", name + " m" + baseSeed + "." + (v + 1));
    written++;
  }

  post("MIDI Mutator: wrote " + written + " variation(s) in " +
       NOTE_NAMES[root % 12] + " " + scaleName + " (seed " + baseSeed + ")\n");
}

// Debug helper: send the message "getkey" to print what the device sees.
function getkey() {
  var song = new LiveAPI("live_set");
  var root = num(song.get("root_note"));
  var scaleName = str(song.get("scale_name"));
  post("MIDI Mutator: global key is " + NOTE_NAMES[root % 12] + " " + scaleName +
       (SCALES[scaleName] ? "" : " (unknown scale — falling back to chromatic)") + "\n");
}

// ---------------------------------------------------------------------------
// Mutation engine
// ---------------------------------------------------------------------------
function mutateNotes(notes, length, allowed, rng) {
  var p = params;
  var out = [];

  // Never delete below 40% of the original notes.
  var minKeep = Math.max(1, Math.ceil(notes.length * 0.4));
  var mayDelete = notes.length - minKeep;

  for (var i = 0; i < notes.length; i++) {
    var n = notes[i];
    var eligible = rng() * 100 < p.amount;

    if (eligible && mayDelete > 0 && rng() * 100 < p.delprob) {
      mayDelete--;
      continue; // note deleted
    }

    var c = cloneNote(n);
    if (eligible) {
      c.pitch = driftPitch(c.pitch, allowed, rng);
      c.velocity = clamp(Math.round(c.velocity + (rng() - 0.5) * 16), 1, 127);
      if (rng() * 100 < p.timing) {
        var t = c.start_time + (rng() < 0.5 ? -GRID : GRID);
        if (t >= 0 && t < length) c.start_time = t;
      }
    }
    out.push(c);
  }

  // Additions: clone existing notes, displace in time and pitch.
  var nAdd = Math.round(notes.length * p.addprob / 100);
  var slots = Math.max(1, Math.round(length / GRID));
  for (var a = 0; a < nAdd; a++) {
    var src = notes[Math.floor(rng() * notes.length)];
    var c2 = cloneNote(src);
    c2.start_time = Math.floor(rng() * slots) * GRID;
    c2.duration = Math.min(src.duration, length - c2.start_time);
    c2.pitch = driftPitch(src.pitch, allowed, rng);
    if (c2.duration > 0 && !collides(out, c2)) out.push(c2);
  }

  return out;
}

function nearestIndex(sorted, v) {
  var best = 0, bestDist = Infinity;
  for (var i = 0; i < sorted.length; i++) {
    var d = Math.abs(sorted[i] - v);
    if (d < bestDist) { bestDist = d; best = i; }
  }
  return best;
}

function driftPitch(pitch, allowed, rng) {
  var idx = nearestIndex(allowed, pitch);
  var steps = 1 + Math.floor(rng() * params.drift);
  var dir = rng() < 0.5 ? -1 : 1;
  return allowed[clamp(idx + dir * steps, 0, allowed.length - 1)];
}

function cloneNote(n) {
  return {
    pitch: n.pitch,
    start_time: n.start_time,
    duration: n.duration,
    velocity: n.velocity,
    mute: n.mute || 0,
    probability: (n.probability !== undefined) ? n.probability : 1,
    velocity_deviation: n.velocity_deviation || 0,
    release_velocity: n.release_velocity || 64
  };
}

function collides(list, note) {
  for (var i = 0; i < list.length; i++) {
    if (list[i].pitch === note.pitch &&
        Math.abs(list[i].start_time - note.start_time) < 0.01) return true;
  }
  return false;
}

// ---------------------------------------------------------------------------
// Live API helpers
// ---------------------------------------------------------------------------
function addNotes(clipApi, arr) {
  var payload = { notes: arr };
  try {
    clipApi.call("add_new_notes", payload);
  } catch (e) {
    // Some Max versions want the dict as a JSON string instead of an object.
    clipApi.call("add_new_notes", JSON.stringify(payload));
  }
}

function allowedPitches(root, intervals) {
  var out = [];
  for (var p = 0; p < 128; p++) {
    if (intervals.indexOf(((p - root) % 12 + 12) % 12) !== -1) out.push(p);
  }
  return out;
}

// LiveAPI get() may return a scalar or an array depending on property/version.
function num(x) {
  if (Array.isArray(x)) return Number(x[0]);
  return Number(x);
}

function str(x) {
  if (Array.isArray(x)) return x.join(" ");
  return (x === null || x === undefined) ? "" : String(x);
}

// ---------------------------------------------------------------------------
// Utils
// ---------------------------------------------------------------------------
function clamp(v, lo, hi) { return Math.min(hi, Math.max(lo, v)); }

// Small, fast seeded RNG — same seed always gives the same variation.
function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    var t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
