# RUNTIME_WORKFLOW.md

This file defines how active runtime is created, archived, switched, and restored.

## 1. Canonical rule

`campaign/` is a working copy of one campaign folder.
Its structure must match `campaigns/<name>/`.

## 2. Folder rule

Every campaign folder and active runtime use:
- `cast/`
- `run/`
- `run_archive/`

`run/` = current working run
`run_archive/` = completed or parked runs

## 3. Starting a fresh run inside an existing campaign

1. Ensure `CAMPAIGN.md`, `WORLD.md`, `SIMULATION_RULES.md`, `world_state.json`, and `cast/` are ready.
2. Reset `run/story_log.md`, `run/turn_log.jsonl`, `run/tick_snapshots.jsonl`, `run/review_summary.md` if you are intentionally starting a new clean run.
3. Copy campaign root `world_state.json` into `run/world_state.json`.
4. Update `run/metadata.json` with new `run_id`, status, active cast, and validity baseline.
5. Only then launch Run DM.

## 4. Finishing a run

1. Stop the run.
2. Make sure `run/metadata.json` is up to date.
3. Copy the full contents of `run/` into `run_archive/log-YYYY-MM-DD-run-N-name/`.
4. If this run becomes the new canonical continuation, copy `run/world_state.json` back to campaign root `world_state.json` and sync changed cast files.

## 5. Switching active campaign

Before replacing `campaign/`:
1. Detect whether current `campaign/run/` contains meaningful work.
2. If yes, archive it into that campaign's `run_archive/`.
3. If current runtime should remain the latest continuation, sync `run/world_state.json` back into campaign root `world_state.json` and sync changed cast files.
4. Save the current `campaign/` back into its source folder under `campaigns/<name>/`.
5. Only then replace `campaign/` with a copy of the next selected campaign folder.

Never discard `campaign/run/` silently during a switch.

## 6. Restoring a past run

To inspect or resume a past run:
1. copy archived run files from `run_archive/<run_id>/` into `run/`
2. verify `metadata.json` and `world_state.json`
3. ensure cast continuity matches the restored point
4. only then resume or review

## 7. If runtime is broken

If `run/` files contradict each other:
- do not invent continuity,
- report what conflicts,
- repair explicitly,
- archive the repaired state separately if needed.


## 8. Standard script

The canonical helper for these operations is `scripts/runtime_ops.py`.
Lab DM should prefer using it over inventing a fresh copy/archive procedure.
