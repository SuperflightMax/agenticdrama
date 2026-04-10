# RUN_ARTIFACTS_SPEC.md

This file defines the required runtime artifacts under `campaign/run/`.
Run DM and Lab DM should both use it.

## 1. Required files

Active runtime files:
- `story_log.md`
- `turn_log.jsonl`
- `tick_snapshots.jsonl`
- `world_state.json`
- `metadata.json`
- `review_summary.md`

## 2. General rules

- User-facing artifacts must be in Russian.
- Machine-oriented files may use English keys.
- Runtime logs are append-only unless explicitly repairing a broken log.
- Do not hide skipped model layers.
- The files already present in `campaign/run/` are working files. Continue them. Do not delete and recreate style from memory.

## 3. `story_log.md`

Purpose:
- readable account of the run for the owner,
- focused on what happened and how it was experienced,
- not literary prose,
- not raw machine data.

Structure:
1. short title / run id / tick span,
2. short cast block (one line per character),
3. short environment block,
4. tick-by-tick sections.

Each tick should clearly show:
- what was said (in plain readable form),
- what was done,
- what changed.

When a new episode is injected during a run, add one short human-readable note to `story_log.md` that the injection happened and what pressure was introduced.
Do not present guilt, motive, or outcome as fact in that note.
The actual causal patch must still be visible in world state / snapshots.

Keep it short.
Keep it Russian.
Do not include raw ids or JSON fragments.

## 4. `turn_log.jsonl`

Purpose:
- machine-readable event log.

Rules:
- one JSON object per line,
- append-only,
- enough detail to reconstruct what was rendered and what was returned.

For significant ticks, include at least:
- perceived-state render or equivalent,
- `player_response`,
- consequence / update events,
- `tick_completed`.

## 5. `tick_snapshots.jsonl`

Purpose:
- one post-resolution snapshot per tick.

Rules:
- one JSON object per line,
- store the world-state slice that matters for continuity,
- include player state slices and relevant world notes.

## 6. `metadata.json`

Purpose:
- run identity,
- validity,
- active cast,
- layer usage,
- unresolved issues,
- source campaign.

## 7. `review_summary.md`

Review artifact written after inspection of the run.
Russian, owner-facing, and honest about validity and missing layers.
