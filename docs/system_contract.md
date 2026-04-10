# AI SOCIAL SANDBOX — SYSTEM CONTRACT

## 1. Project essence

The core truth lives in:
- `docs/simulation_agents_life_core.md`
- `docs/MEMORY_MODEL.md`

This project simulates how behavior emerges from:
- state,
- perception,
- memory,
- appraisal,
- action pulls,
not from story logic.

Required chain:

world event  
→ cues  
→ attention  
→ memory activation  
→ appraisal  
→ state shift  
→ action pulls  
→ decision  
→ action  
→ consequence

Breaking this chain is forbidden.

## 2. Roles

### Lab DM
Persistent lab operator.
Owns:
- campaign assembly,
- episode template selection and campaign-specific concretization,
- runtime activation / switching,
- Run DM packet compilation,
- review.

Does not directly simulate the run.
Must not substitute a persistent DM chat/thread for a fresh Run DM spawn.

### Run DM
Per-run simulation operator.
Owns:
- subjective perception,
- player packet assembly,
- consequence resolution,
- memory / continuity updates,
- runtime logging.

Does not own future campaign episode planning unless Lab DM explicitly hands that scope into the current packet.
Must be fresh per run and must stop writing if its `run_id` is invalidated by kill/reset.
Must not simulate player decisions itself. It must query actual player agents and use their returned responses, or stop blocked.

### Player agents
Per-character runtime actors.
Own:
- bounded subjective response.
Do not own archival memory storage.
For clean runtime separation, they should be launched as one fresh isolated agent/session per active character.

### Runtime worker
Technical helper.
Owns:
- copy,
- archive,
- restore,
- scaffolding.
No model decisions.

## 3. Sources of truth

### Project truth
- `docs/simulation_agents_life_core.md`
- `docs/MEMORY_MODEL.md`
- `docs/CAMPAIGN_TEMPLATE_SPEC.md`
- `docs/RUN_ARTIFACTS_SPEC.md`
- `docs/RUNTIME_WORKFLOW.md`
- `docs/EPISODE_SYSTEM.md`
- `LAB_OPERATIONS.md`
- `protocol.md`
- `rules.md`
- `CONVENTIONS.md`

### Runtime truth
- `campaign/run/*`
- `campaign/cast/*`

Campaign management truth:
- `campaign/CAMPAIGN.md` is for Lab DM only.
- Do not include it in Run DM packet.

## 4. Repo shape

### Root
- `AGENTS.md`
- `SOUL.md`
- `LAB_OPERATIONS.md`
- `protocol.md`
- `rules.md`
- `CONVENTIONS.md`
- `RUN_DM_INIT_TEMPLATE.md`
- `PLAYER_AGENT_INIT_TEMPLATE.md`
- `CHARACTER_TEMPLATE.md`
- `REVIEW_TEMPLATE.md`
- `episodes/`

### Campaign storage
`campaigns/<name>/`
- `CAMPAIGN.md`
- `WORLD.md`
- `SIMULATION_RULES.md`
- `world_state.json`
- `cast/`
- `episode_plan.json`
- `run/`
- `run_archive/`

### Active runtime
`campaign/`
- same shape as storage campaign
- active runtime may also carry `run/episode_state.json`

## 5. Runtime artifact rules

Current working run:
`campaign/run/`
- `story_log.md`
- `turn_log.jsonl`
- `tick_snapshots.jsonl`
- `world_state.json`
- `metadata.json`
- `review_summary.md`

Archived runs:
`campaign/run_archive/<archive_name>/`
and after snapshot in
`campaigns/<name>/run_archive/<archive_name>/`

Runtime logs are append-only unless explicitly repairing a broken log.
`story_log.md` should visibly mark episode injections in human-readable form when they happen during a run.
If direct speech exists in runtime artifacts, `story_log.md` should preserve that speech verbatim instead of paraphrasing it away.

## 6. Memory

Canonical storage:
`campaign/cast/<character>/memory_imprints.json`

Run DM owns memory servicing.
Player agents receive only memory effects, not raw storage.

## 7. Review

Review is outside the run.
Lab DM reads campaign purpose and runtime artifacts, then writes `review_summary.md`.

## 8. Anti-patterns

Forbidden:
- story steering instead of causality,
- giving Run DM experiment goals as runtime steering,
- player omniscience,
- skipping active model layers silently,
- using agent chat memory as stronger truth than files,
- Run DM fabricating missing player responses instead of querying real player agents.
