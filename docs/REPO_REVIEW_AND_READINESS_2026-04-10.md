# REPO_REVIEW_AND_READINESS_2026-04-10

This file is a practical final review of the current repository state.
It focuses on whether the lab can actually launch and run campaigns without silently inventing workflow.

## Verdict

The repo is now **launchable for first real model tests**.
Not finished forever, but no longer stuck in the previous limbo where key workflow pieces were implied instead of canonized.

The strongest current shape is:
- one active runtime in `campaign/`
- storage campaigns in `campaigns/<name>/`
- Bash-first operational entrypoint in `scripts/runtime_ops.sh`
- campaign-local cast files and baseline world state
- explicit episode queue for structured pressure exposure
- runtime episode tracker in `campaign/run/episode_state.json`

## What was good already

- The project truth files are split sanely.
- Lab DM / Run DM / player roles are separated.
- Campaign and active runtime use the same folder shape.
- Test campaigns already had meaningful characters and usable world pressure.
- The social test campaign is materially grounded enough to produce non-trivial appraisal differences.

## What was broken or risky and is now fixed

### 1. Runtime switch risk
Before this pass, activation logic could silently replace active runtime.
Now activation preserves outgoing runtime by archiving and snapshotting first.

### 2. Linux operational mismatch
Operational helper is now Bash-first instead of pretending Python is the natural shell entrypoint on Linux VPS.

### 3. Doc / command mismatch
Docs now point to `bash scripts/runtime_ops.sh ...` instead of stale `python3 scripts/runtime_ops.sh ...` examples.

### 4. `runs/` vs `run/`
Stray `runs/` ambiguity was removed.
Canonical current working run folder is only `run/`.

### 5. Missing episode canon
The repo previously had scenario seeds, but not a canonical mechanism for:
- reusable situation templates,
- ordered campaign episode queue,
- targeted injection of the next situation,
- carrying forward state / memory / relations without reset.

That layer is now added.

### 6. `new-run` erased episode progression state
Fresh run creation now recreates `run/episode_state.json` and seeds pending episode ids from `episode_plan.json`.

## Current chain check

### A. Session bootstrap
`AGENTS.md` now points the operator through:
- project truth files,
- active campaign files,
- episode plan,
- active episode tracker,
- current runtime logs.

This is good enough to stop the agent from pretending the workspace is ready without checking.

### B. Campaign creation
Template now includes:
- `episode_plan.json`
- `episode_templates/`
- `run/episode_state.json`

That means a new campaign can be copied and immediately edited without inventing extra folders later.

### C. Campaign activation
`bash scripts/runtime_ops.sh activate <name>` now behaves like a real switch operation:
- archive outgoing run if meaningful
- sync run world state back to root campaign state
- snapshot outgoing active runtime back into storage
- only then replace active runtime with selected campaign

This is the right shape.

### D. New run creation
`bash scripts/runtime_ops.sh new-run --run-id <id>` now:
- archives previous run
- resets working run files
- copies campaign root world state into run world state
- rebuilds metadata
- rebuilds episode progression tracker

This is now coherent.

### E. Run launch packet readiness
For the `test` campaign, Run DM can now be launched with a coherent packet because the campaign has:
- cast with differentiated souls, states, relations, and imprints
- world with actionable zones / resources / visibility constraints
- simulation rules with declared layers
- episode queue with non-forcing pressure situations

### F. Episode advancement
The new canon is:
- episode templates live in `episode_templates/`
- campaign-selected sequence lives in `episode_plan.json`
- current episode progress lives in `run/episode_state.json`
- advancing to next episode means apply only targeted delta and keep everything else unless explicitly overridden

This matches the desired memory / continuity behavior much better.

## Mental dry run: `trust_pressure_test`

### Initial launch
Lab DM activates `test`, starts a fresh run, sees:
- Anya + Rita in shelter main room
- Nikita in yard
- cold evening setup
- light becoming scarce
- no promise yet in `world_state.json`, but episode queue ready

### Episode 1 injection
Lab DM injects `ep01_unmet_promise_water_and_battery`.
World continuity receives a pending promise record.
Nikita is now the promiser and initial actor under outside-zone pressure.

What Run DM should be able to do from current repo:
- expose waiting, cold, and incomplete visibility differently to each character
- activate Anya's waiting / omission sensitivity
- activate Nikita's shame / overpromise vulnerability if delay starts hurting
- let Rita read practical reality before emotional meaning, unless burden starts stacking

This should work.

### Episode 2 carry-forward
If episode 1 ends with partial fulfillment, excuse, delay, or even successful repair, episode 2 can still expose uneven burden without resetting anyone.
That is important: resentment, relief, distrust, or softening now have a place to persist.

### Episode 3 ambiguity
Missing shared resource is a good third test because it checks whether the system can hold uncertainty instead of snapping to fake truth.
The current campaign assets support this.

### Episode 4 outside pressure
This is where the campaign stops being only a relationship test and becomes a survival / cooperation test.
Good addition.

### Episode 5 repair attempt
Good late-stage check: positive intent should not magically land the same way after different histories.

## Remaining limitations

These are not blockers for first launch, but they are real:

### 1. No automatic patch applicator yet
The repo now has canonical episode files, but there is not yet a dedicated script that applies `episode_plan.json -> world_state.json` as a structured patch.
Right now Lab DM / Run DM must do that intentionally and explicitly.

### 2. No hard schema validation
JSON shape is consistent enough for manual use, but there is no validator that checks every campaign file before launch.

### 3. Cast sync after run still depends on disciplined operator behavior
World state sync is explicit in workflow, but cast continuity / memory sync still depends on Run DM and review discipline rather than a dedicated helper.

## Practical recommendation

At this point, stop rebuilding the repo and start running it.
Use:
- `test_minimal` for pipeline sanity
- `test` for the first meaningful model evaluation

The next useful work after real runs is likely not more file architecture.
It is observing where Run DM still tends to:
- over-certify truth,
- flatten ambiguity,
- skip appraisal detail,
- or fail to carry relation drift honestly.
