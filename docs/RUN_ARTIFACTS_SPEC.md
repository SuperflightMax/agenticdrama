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

`story_log.md` is a chronological readable log, not a retold scene.
If direct speech exists in runtime artifacts, preserve it verbatim instead of replacing it with descriptive paraphrase.
Broader interpretation belongs in `review_summary.md`, not in `story_log.md`.

Structure:
1. short title / run id / tick span,
2. short cast block (one line per character),
3. short environment block,
4. tick-by-tick sections.

Each tick should clearly show:
- who said what (prefer direct quotes when they exist),
- who did what,
- what changed.

Prefer an explicit plain sequence over descriptive summary. Good runtime logging looks like:
- `Аня → Никита: "Ты обещал воду до темноты."`
- `Никита возвращается из насосной с канистрой, но без батареи.`
- `Рита кладёт дрова у печи.`
- `Последствия: обещание остаётся частично выполненным, у Ани растёт настороженность.`

Avoid explanatory paraphrase when concrete speech or action is available.

When a new episode is injected during a run, add one short human-readable note to `story_log.md` that the injection happened and what pressure was introduced.
Do not present guilt, motive, or outcome as fact in that note.
The actual causal patch must still be visible in world state / snapshots.

Keep it short.
Keep it Russian.
Do not include raw ids or JSON fragments.
Do not replace a known quote with summary phrasing such as "Никита ругал печку" when the actual quote is available.

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
