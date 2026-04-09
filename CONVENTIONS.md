# CONVENTIONS.md — formatting and behavior conventions

## 1. Language policy

Use **English** for internal instructions and system docs.
Use **Russian** for user-facing artifacts.

User-facing artifacts include:
- `story_log.md`
- `review_summary.md`
- owner-facing run summaries

Machine-oriented files may use English keys and mixed content where appropriate:
- `turn_log.jsonl`
- `tick_snapshots.jsonl`
- `metadata.json`
- `world_state.json`

## 2. Artifact authority

Formatting rules for runtime artifacts live in:
- `docs/RUN_ARTIFACTS_SPEC.md`
- current working files in `campaign/run/`

If an artifact format is unclear, do not improvise a new style silently.
Use the spec or ask.

## 3. Story log discipline

`story_log.md` is a readable log of what happened in the run.
It is **not** a novel and **not** a technical dump.

Structure:
1. short heading (campaign / run id / tick span),
2. one-line cast list,
3. short environment block,
4. tick sections.

Inside each tick:
- who said what, directly and plainly,
- who did what,
- short consequences.

Good:
- `Аня → Никита: "Ты обещал принести воду."`
- `Никита идёт к насосу.`
- `Последствия: вода не появилась, напряжение между Аней и Никитой растёт.`

Do not include:
- raw ids,
- JSON,
- intent fields,
- protocol keys,
- location ids unless they are naturally readable,
- literary padding.

## 4. Ambiguity must stay ambiguous

If hearing, visibility, motive, or social meaning is ambiguous, keep it ambiguous.
Do not convert uncertainty into false certainty just to make the log neat.

## 5. Runtime integrity

If a model layer was skipped or only partially computed, logs and summaries must not pretend otherwise.
Say it plainly.
