# Changelog

All notable changes to MIDI Mutator are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-11-07

First public release.

### Added

- Mutation engine (`mutator.js`) running in a `[v8]` object: reads Live's
  global Key & Scale and the focused Session clip, then writes N seeded
  variations into the empty clip slots below it on the same track.
- Mutation model tuned to preserve the source's character — partial note
  eligibility (Amount), pitch drift measured in scale degrees rather than
  semitones, additions cloned from existing notes, deletion floored at 40%
  of the original note count, and a `mulberry32` seeded RNG so any seed
  reproduces the same family of variations.
- Device UI with Amount, Drift, Delete, Add, Timing, Vars and Seed controls
  plus a Mutate button.
- Scale table covering Live 12's common scales, falling back to chromatic on
  unknown or exotic scales rather than failing.
- Prebuilt `MIDI Mutator.amxd` alongside the `.maxpat` source.
- README with both install paths, controls reference, starting recipes,
  mutation design notes, troubleshooting table and roadmap.

### Known limitations

- Session view only; Arrangement clips are not supported.
- Note locking is all-or-nothing via the Amount control. Per-note locking
  arrives with the planned v2 MIDI Tools port.

[1.0.0]: https://github.com/tbmorgan70/midi-mutator/releases/tag/v1.0.0
