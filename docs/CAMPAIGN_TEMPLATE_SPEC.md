# CAMPAIGN_TEMPLATE_SPEC.md

Read this before creating, repairing, copying, or switching campaigns.

## 1. Canonical campaign structure

Global reusable episode library at repo root:

```text
episodes/
  <template_id>.md
  README.md
```

Every campaign folder should use the same structure:

```text
campaigns/<name>/
  CAMPAIGN.md
  WORLD.md
  SIMULATION_RULES.md
  world_state.json
  cast/
  episode_plan.json
  episode_templates/
  run/
    story_log.md
    turn_log.jsonl
    tick_snapshots.jsonl
    world_state.json
    metadata.json
    review_summary.md
  run_archive/
```

The active runtime folder uses the same shape:

```text
campaign/
  CAMPAIGN.md
  WORLD.md
  SIMULATION_RULES.md
  world_state.json
  cast/
  episode_plan.json
  episode_templates/
  run/
  run_archive/
```

This is deliberate.
A campaign folder must be copyable into `campaign/` without structural surgery.

## 2. File roles

### `CAMPAIGN.md`
- campaign name
- lab purpose
- source templates used
- active cast
- main pressures
- important deviations

### `WORLD.md`
- zones
- objects
- resources
- pressures
- affordances
- constraints as natural conditions

### `SIMULATION_RULES.md`
Ready baseline rules for this campaign.
Do not leave it as a blank promise.
If this campaign deviates from baseline, state it here explicitly.

### `world_state.json`
Baseline world state for this campaign outside the live run.

### `cast/`
Active characters for this campaign.


### `episode_plan.json`
Ordered campaign-specific episode queue.
Contains instantiated situation entries and their targeted injection patches.

### `episode_templates/`
Optional campaign-local concretization notes or local copies for episode templates already chosen from the global `episodes/` library.
Do not treat this folder as the only source of reusable templates across the repo.

### `run/`
Live working run files.
Run DM writes here.

### `run_archive/`
Completed or parked runs copied out of `run/`.

## 3. Runtime rule

`run/` exists in templates, ready campaigns, and active runtime.
It is always present and already contains the working artifact files.

Do not require special one-off creation steps just to start a run.

## 4. Archive rule

When a run is finished or when active runtime is switched away:
- preserve the current `run/` under `run_archive/log-YYYY-MM-DD-run-N-name/`
- keep the archived files together
- if the run produced the new canonical continuation, sync `run/world_state.json` back into campaign root `world_state.json`

Exact operational steps are defined in `docs/RUNTIME_WORKFLOW.md`.


## Packet safety

`CAMPAIGN.md` is for Lab DM and review context. It should not be injected into the runtime packet for Run DM.

## 5. Episode source rule

Global reusable templates live in `episodes/`.
Lab DM should choose from that library when building a campaign, concretize selected templates for the current world and cast, and write those concrete instances into `episode_plan.json`.
If a campaign produces a new reusable situation shape, add it back into `episodes/`.
