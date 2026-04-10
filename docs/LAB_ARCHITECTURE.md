# LAB_ARCHITECTURE.md

## Purpose

The lab is split so that project knowledge, runtime simulation, player subjectivity, and file operations do not collapse into one magical agent.

## Roles

### 1. Lab DM
Persistent project operator.
Responsibilities:
- project continuity,
- docs,
- campaign assembly,
- episode template selection and campaign-specific concretization,
- runtime activation / switching,
- run review.

### 2. Run DM
Per-run simulation operator.
Responsibilities:
- subjective perception,
- player packet assembly,
- consequence resolution,
- memory / continuity updates,
- runtime logging.

Run DM is bounded by a distilled packet and normally does not need the future episode queue beyond the current active episode context.
Run DM must be launched fresh per run and must never be faked by sending instructions into another persistent DM session.

### 3. Player agents
Per-character runtime actors.
Responsibilities:
- live inside their subjective packet,
- return `player_response`,
- preserve continuity of reaction during the run.

### 4. Runtime worker
Technical support role.
Responsibilities:
- copy,
- archive,
- restore,
- no model decisions.

## Sources of truth

### Project truth
- `docs/simulation_agents_life_core.md`
- `docs/MEMORY_MODEL.md`
- `docs/CAMPAIGN_TEMPLATE_SPEC.md`
- `docs/RUN_ARTIFACTS_SPEC.md`
- `docs/RUNTIME_WORKFLOW.md`
- `protocol.md`
- `rules.md`
- `CONVENTIONS.md`

### Runtime truth
- `campaign/run/*`
- `campaign/cast/*`

## Why the split exists

1. To stop runtime from making up its own rules.
2. To stop players from becoming omniscient.
3. To separate project memory from subjective memory.
4. To keep review outside the run itself.
5. To make recovery possible from files, not chat luck.


## Operational note

For campaign creation, activation, run switching, and restore, Lab DM should use `LAB_OPERATIONS.md` and `scripts/runtime_ops.sh` instead of inventing ad-hoc file workflows.

## Important packet rule

`campaign/CAMPAIGN.md` is a Lab DM file. It should not be injected into Run DM runtime packet because it contains experiment purpose.

## Runtime isolation rule

Every real run must have its own `run_id`.
Only the current Run DM for that `run_id` may write active runtime artifacts.
If a run is killed, reset, or replaced, any later output from the invalidated old run/session must be ignored.
