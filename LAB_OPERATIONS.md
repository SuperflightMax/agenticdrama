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

## Canonical runtime agents

Use these dedicated persistent agents:
- `dm` = Lab DM
- `rundm` = Run DM
- `runplayer01` .. `runplayer06` = reusable player containers

These are persistent OpenClaw agents, but **not** persistent characters.
Each concrete run must use fresh run sessions and fresh start packets.

### Canonical session naming

For one run id `<run_id>` use:
- Run DM session key: `run:<run_id>:rundm`
- Player session keys: `run:<run_id>:player:01` .. `run:<run_id>:player:06`

Do not continue a previous run by accident through `main`.
Use `main` only for long-lived operator chat, not for simulation runs.

### Player container rule

`runplayerXX` agents are reusable containers.
Their workspace bootstrap should contain only the role frame and reply discipline.
Concrete character identity, current state, relation slice, continuity, and active memory effects are injected at run start for the current run session.

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

Launch rule:
- use the dedicated persistent agent `rundm`
- start a **fresh run session** for this run; do not reuse an older unrelated run session
- do not reuse Lab DM itself as simulator
- do not route the run into another persistent DM session such as `agent:dm:main`
- do not try to spawn Run DM as a subagent
- player actors are the persistent agents `runplayer01` .. `runplayer06`, each with a fresh run session for this run
- if clean run sessions cannot be prepared, stop and report the block instead of collapsing roles

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

Operationally, each meaningful run/baseline/episode progression should start from a fresh Run DM session with a freshly compiled packet, then hand results back to Lab DM.

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

## Start-packet discipline for dedicated agents

### Run DM start packet
`rundm` already loads its own bootstrap from its own workspace.
Lab DM should therefore send only the **run-specific start packet**, not the whole project doc bundle again.

Send to `rundm` at run start:
- run id and session intent
- compiled run rules / deltas needed for this concrete run
- active runtime world packet
- active cast packet from `campaign/cast/*`
- current runtime artifact status from `campaign/run/*`
- player roster mapping to `runplayerXX` sessions
- the player packet template / response contract

Do **not** resend the full lab bootstrap unless `rundm` workspace is known to be missing it.
Do **not** include `campaign/CAMPAIGN.md`.

### Player start packet
Each `runplayerXX` agent already loads its own minimal role bootstrap.
At run start Lab DM or Run DM should send only:
- assigned character id / name
- short soul / personality profile for this run
- current state snapshot
- relations slice
- continuity summary
- active memory effects and active subjective biases
- reply schema reminder if needed

Do not inject raw repo docs into players.
Do not inject raw `memory_imprints.json` storage into players.

### Tick updates
After run start, Run DM should send only per-tick subjective packets to the player sessions.
Do not recreate or replace the entire player identity every tick unless the run is being repaired from files.
