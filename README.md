# MIDI Mutator

A Max for Live device that takes a MIDI clip you already like and breeds
variations of it — in key, in rhythm, and recognisably related to the original.

Not an arpeggiator. Not a melody generator. It treats your existing clip as
source material and evolves it, so the output sounds like *your* riff mutated
rather than dice rolled in a scale.

Press **Mutate** and N new clips appear in the empty slots below the source.

## Why

There's a well-worn gap in the Ableton ecosystem: plenty of tools *generate*
MIDI from nothing, and plenty *transform* it deterministically, but very few
let you keep a phrase you wrote and push it around under controlled randomness
— the Elektron-style "lock the parts you like, re-roll the rest" workflow.
The tools that got close are either abandoned, hardware, or arpeggiator-shaped.

This is a small, hackable attempt at that missing piece. The whole mutation
engine is ~250 lines of readable JavaScript in [`mutator.js`](mutator.js) —
change the rules, save, and the device hot-reloads.

## Status

**v1 — working.** Generates scale-constrained variations from any Session
clip. Known limits:

- **Session view only.** Arrangement clips are not supported yet.
- Note "locking" is all-or-nothing via the Amount control; per-note locking
  arrives with the v2 MIDI Tools port (see [Roadmap](#roadmap)).

## Requirements

- **Ableton Live 12** Suite, or Live 12 Standard + the Max for Live add-on.
- Max 8.6+ — bundled with Live 12, nothing extra to install.

Built and tested on Windows; nothing in it is platform-specific.

## Install

### Option A — use the prebuilt device (fastest)

1. Download or clone this repo.
2. In Live's browser sidebar, scroll to **Places → Add Folder…** and add the
   repo folder.
3. Drag **`MIDI Mutator.amxd`** onto any MIDI track.

> **Keep the files together.** The device loads `mutator.js` from the folder
> next to it. Copying the `.amxd` alone into your User Library will break it.

### Option B — build it from the patch

Max for Live devices have to be saved from inside Live, so the source ships as
a `.maxpat` you paste in once:

1. In Live's browser: **Max for Live → Max MIDI Effect**, drag it onto a MIDI
   track.
2. Click the device's **Edit** button (pencil icon) to open the Max editor.
3. **Edit → Select All → Delete** to clear the template.
4. **File → Open…** → `midi_mutator.maxpat`.
5. In that window make sure **View → Presentation is OFF** — otherwise Select
   All grabs only the UI knobs and silently skips the engine. You should see
   ~20 objects including `v8 mutator.js`, `midiin`/`midiout`, and a row of
   `prepend` objects. Then **Select All → Copy**, close the window, and
   **Paste** into the empty device patcher.
6. Turn the polished UI back on: click empty canvas so **nothing** is selected,
   open **View → Inspector Window** (Ctrl+Shift+I) for the *patcher's*
   attributes, and tick **Open in Presentation**. Skip this and Live draws the
   raw patching view with the dials cropped off the bottom.
7. **File → Save As…** → save as `MIDI Mutator.amxd` **into this folder**, next
   to `mutator.js`.
8. Close the editor.

## Quick start

1. Set Live's **Key & Scale** (top-left of the control bar). The device reads
   this *global* setting, not the clip's own scale.
2. Put the device on a MIDI track.
3. Make sure there are **empty clip slots below** your source clip — that's
   where variations get written.
4. **Double-click the source clip** so it opens in the clip detail view. The
   device acts on whatever is focused there.
5. Press **Mutate**. New clips appear, named `<clip name> m<seed>.<n>`.

Don't like them? Delete and press again — with **Seed = 0** every press rolls
fresh dice.

## Controls

| Control | Range | What it does |
|---|---|---|
| **Amount** | 0–100% | Fraction of notes eligible for mutation. The rest pass through untouched — this is the "retain the original" knob. |
| **Drift** | 1–7 | Maximum pitch move, in *scale degrees* (not semitones). 1–2 stays melodic. |
| **Delete** | 0–100% | Chance an eligible note is removed. Hard floor at 40% of the original note count, so a clip can't collapse to nothing. |
| **Add** | 0–100% | New notes as a percentage of the original count. Additions are cloned from existing notes, not invented. |
| **Timing** | 0–100% | Chance an eligible note is nudged by a 16th. 0 = rhythm fully preserved. |
| **Vars** | 1–8 | How many variation clips to write per press. |
| **Seed** | 0–99999 | 0 = random every press. Any other value is reproducible. |

### Starting recipes

| Goal | Amount | Drift | Delete | Add | Timing |
|---|---|---|---|---|---|
| Subtle section variation | 30% | 1 | 5% | 5% | 0 |
| B-section generator | 60% | 2 | 15% | 15% | 0 |
| Acid mangler | 80% | 3–4 | 25% | 30% | 30% |

Found one you love? Select **that** clip and press Mutate again — mutations of
mutations is where it gets interesting. The seed is in the clip name, so you
can always regenerate a family.

## How the mutation works

The design goal is *recognisable* variation, so the engine deliberately avoids
uniform randomness:

- **Partial eligibility.** Only `Amount` percent of notes are candidates at
  all. Everything else is copied verbatim, which preserves the skeleton.
- **Scale-degree drift.** Pitches move by 1..`Drift` steps along the song's
  scale, not by semitones — so mutations land in key by construction rather
  than being quantised after the fact.
- **Derived additions.** New notes are clones of existing notes, displaced in
  time and pitch. Additions inherit the clip's own velocity and duration
  character instead of introducing foreign material.
- **Floored deletion.** Deletion can never take a clip below 40% of its
  original notes.
- **Seeded RNG.** A `mulberry32` generator means a given seed always produces
  the same family of variations — reproducible, and diffable while tuning.

Scale intervals for Live 12's common scale names are in the `SCALES` table;
unknown or exotic scales fall back to chromatic rather than failing.

## Troubleshooting

Open the Max Console (device **Edit** button → **Window → Max Console**). The
device narrates itself there — on success you'll see
`wrote 4 variation(s) in D Minor (seed 4821)`.

| Symptom | Cause |
|---|---|
| `no clip selected` | No clip focused in the detail view — double-click one. |
| `Arrangement clips aren't supported yet` | v1 is Session view only. |
| `ran out of empty slots` | Add scenes below the source clip. |
| `clip needs at least 2 notes` | Single-note clips have nothing to vary. |
| UI cropped, raw objects visible | Patcher's **Open in Presentation** is off — see install step 6. |
| Variations in the wrong key | The **global** Key & Scale doesn't match the clip. |

Dual monitors: Live's second window works fine — the device reads Live's single
global "focused clip", so it doesn't matter which screen the clip is on.

## Roadmap

- **v2 — per-note locking.** Port the engine to a Live 12.1 **MIDI
  Transformation tool** so it runs in the clip editor's Transform tab and
  operates on *selected notes only*, with the built-in re-roll/apply loop.
- **Harmony mode.** Scale-aware 3rds/6ths stacked on the mutated line; chord
  pads extracted from the strongest beats.
- **Markov extrapolation.** Learn the source clip's interval and rhythm
  transitions, then *extend* it (2 bars → 8) in the same character.
- **Rhythm modes.** Rotate, half/double time, euclidean redistribution —
  rather than only 16th-note nudges.
- Arrangement clip support.

## Contributing

Issues and PRs welcome, especially: scale table additions, mutation strategies
that preserve musicality, and reports of what the output *sounds* like at
various settings — that's the hard part to test.

## License

MIT — see [LICENSE](LICENSE).
