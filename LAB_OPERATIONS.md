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

## Standard operations

### 1. Create a new campaign from template
Use:
`python3 scripts/runtime_ops.py create-campaign <new_name>`

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
`python3 scripts/runtime_ops.py create-campaign <new_name> --from <source_name>`

Then Lab DM edits whatever must differ.
If the new campaign is supposed to have clean memory, Lab DM must clean:
- `cast/*/memory_imprints.json`
- `cast/*/continuity_notes.md`
- `run/*`
- `run_archive/*`

### 3. Activate a campaign
Use:
`python3 scripts/runtime_ops.py activate <campaign_name>`

This makes `campaign/` a working copy of `campaigns/<campaign_name>/`.

After activation, verify:
- `campaign/CAMPAIGN.md`
- `campaign/WORLD.md`
- `campaign/SIMULATION_RULES.md`
- `campaign/world_state.json`
- `campaign/cast/*`
- `campaign/run/*`

### 4. Start a fresh run in the active campaign
Use:
`python3 scripts/runtime_ops.py new-run --run-id <run_id>`

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
`python3 scripts/runtime_ops.py snapshot <campaign_name>`

This copies current `campaign/` back into `campaigns/<campaign_name>/`.

Use it:
- after meaningful progress,
- before switching away,
- after a run review if active runtime is now the canonical continuation.

### 7. Restore an archived run into current working run
Use:
`python3 scripts/runtime_ops.py restore-run <archive_name>`

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
