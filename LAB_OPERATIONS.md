# LAB_OPERATIONS.md — operational workflow for Lab DM

This file is the single practical place for campaign creation, activation, run switching, and review workflow.
Use it so you do not invent a different file workflow every time.

## Roles in operations

- **Lab DM** decides and assembles.
- **Runtime Worker / scripts** copy, archive, restore, and scaffold.
- **Run DM** simulates one run.
- **Player agents** react inside one run.

Never collapse these roles.

## Canonical folders

### Storage campaign
`campaigns/<name>/`

### Active runtime
`campaign/`

### Current working run
`campaign/run/`

### Global episode library
`episodes/`

### Episode queue
`campaign/episode_plan.json`

### Campaign-local episode notes / concretization copies
`campaign/episode_templates/`

### Active episode tracker
`campaign/run/episode_state.json`

### Archived runs
`campaign/run_archive/`
and after snapshot they also live in
`campaigns/<name>/run_archive/`

## When to use Runtime Worker / scripts

Use scripts for:
- creating a new campaign folder from template or from another campaign,
- activating a named campaign into `campaign/`,
- snapshotting active runtime back to storage,
- starting a fresh run inside an active campaign,
- archiving the previous active run,
- restoring a run from archive.

Do not make up manual copy workflows if the script already covers the operation.
Operational entrypoint is Bash-first because target environment is Linux VPS.

## Standard operations

### 1. Create a new campaign from template
Use:
`bash scripts/runtime_ops.sh create-campaign <new_name>`

This copies:
- `campaigns/TEMPLATE/` -> `campaigns/<new_name>/`

Then Lab DM edits:
- `CAMPAIGN.md`
- `WORLD.md`
- `SIMULATION_RULES.md`
- `world_state.json`
- `cast/*`

### 2. Create a new campaign from an existing one
Use:
`bash scripts/runtime_ops.sh create-campaign <new_name> --from <source_name>`

Then Lab DM edits whatever must differ.
If the new campaign is supposed to have clean memory, Lab DM must clean:
- `cast/*/memory_imprints.json`
- `cast/*/continuity_notes.md`
- `run/*`
- `run_archive/*`

### 3. Activate a campaign
Use:
`bash scripts/runtime_ops.sh activate <campaign_name>`

This makes `campaign/` a working copy of `campaigns/<campaign_name>/`.

This preserves the previous active campaign before replacement:
- archives `campaign/run/` if it contains meaningful work,
- syncs `campaign/run/world_state.json` back to campaign root by default,
- snapshots current `campaign/` back into its source storage campaign when source is known,
- only then replaces runtime with the selected campaign.


After activation, verify:
- `campaign/CAMPAIGN.md`
- `campaign/WORLD.md`
- `campaign/SIMULATION_RULES.md`
- `campaign/world_state.json`
- `campaign/cast/*`
- `campaign/run/*`

### 4. Start a fresh run in the active campaign
Use:
`bash scripts/runtime_ops.sh new-run --run-id <run_id>`

This:
- archives the current contents of `campaign/run/` into `campaign/run_archive/<timestamp>-<old_run_id>/` if the current run is non-empty,
- resets current working run files,
- copies `campaign/world_state.json` into `campaign/run/world_state.json`,
- initializes `campaign/run/metadata.json`.

After this, Lab DM may launch Run DM.

### 5. Continue the active run
Do not create a new run.
Use the existing `campaign/run/`.
Run DM continues:
- the existing `story_log.md`
- the existing `turn_log.jsonl`
- the existing `tick_snapshots.jsonl`
- the existing `campaign/run/world_state.json`

### 6. Snapshot active runtime back to storage
Use:
`bash scripts/runtime_ops.sh snapshot <campaign_name>`

This copies current `campaign/` back into `campaigns/<campaign_name>/`.

Use it:
- after meaningful progress,
- before switching away,
- after a run review if active runtime is now the canonical continuation.

### 7. Restore an archived run into current working run
Use:
`bash scripts/runtime_ops.sh restore-run <archive_name>`

This copies:
- `campaign/run_archive/<archive_name>/` -> `campaign/run/`

Use only when you intentionally want to continue from that archived run.

## Run launch checklist for Lab DM

Before launching Run DM, confirm:

1. `campaign/` exists and is the intended campaign.
2. `campaign/world_state.json` is coherent.
3. `campaign/WORLD.md` contains real pressures and affordances.
4. `campaign/SIMULATION_RULES.md` explicitly states active layers and deviations.
5. `campaign/cast/*` is complete for every active character.
6. `campaign/run/metadata.json` exists and names the run.
7. Run DM init packet is compiled.
8. Run DM packet does **not** include `campaign/CAMPAIGN.md`.
9. Player packets will include **memory effects**, not raw memory storage.


## Episode workflow

Episodes are ordered situation injections, not scripted outcomes.

Lab DM should:
1. keep reusable situation shapes in the global `episodes/` library
2. choose from that library when assembling a campaign
3. concretize selected templates for the current world and cast
4. write those campaign-specific episode instances into `campaign/episode_plan.json`
5. optionally keep campaign-local concretization notes or copies in `campaign/episode_templates/`
6. inject only the targeted delta for the next episode
7. preserve current cast state, memory, relations, and world consequences unless the episode explicitly overrides them
8. update `run/episode_state.json` when advancing
9. add newly discovered reusable situation shapes back into `episodes/` when they are generic enough to reuse

Run DM does not own campaign planning.
Run DM may receive only the current episode packet and does not need awareness of future queued episodes unless Lab DM explicitly includes that context.

When one episode finishes and the next begins:
- do not reset cast state by default
- do not clear memory or relations
- do not replace the whole world state if only one pressure changed
- do carry forward unresolved meaning into the next episode

When an episode injection happens:
- the actual causal patch must be visible in runtime world state / snapshots
- `story_log.md` should contain one short human-readable note that an episode injection occurred and what pressure was introduced
- do not write the outcome in that note

See `docs/EPISODE_SYSTEM.md` for the canonical rules.

## Review workflow

When asked for review:
1. Read `campaign/CAMPAIGN.md` for lab purpose.
2. Read the run artifacts:
   - `story_log.md`
   - `turn_log.jsonl`
   - `tick_snapshots.jsonl`
   - `metadata.json`
3. Use `REVIEW_TEMPLATE.md`.
4. Write `campaign/run/review_summary.md` in Russian.

If reviewing an archived run, use the corresponding folder in `campaign/run_archive/` or in storage.

## Core safety rules

- Lab DM must not let Run DM browse the repo for truth.
- Run DM must not receive campaign purpose as a target to optimize for.
- Runtime Worker must not make model decisions.
- Player agents must not receive raw memory storage.
- Runtime logs are append-only, except explicit repair.
