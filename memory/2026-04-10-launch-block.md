# 2026-04-10 Launch blocker

## Status

Blocked at orchestration layer, not at campaign prep.

## Launch blocker

- **Launch blocker:** Lab DM orchestration session has no `sessions_spawn`

## Why it matters

- without `sessions_spawn`, Lab DM cannot legally create fresh isolated Run DM / player agents
- this pushes execution toward forbidden persistent-session paths such as reuse of existing DM sessions
- project rules explicitly forbid substituting persistent DM threads for fresh isolated run sessions

## Required tooling

At minimum:
- `sessions_spawn`

Ideally also:
- `agents_list`
- `subagents`

## After fix

- move run execution to fresh spawned Run DM
- when needed, launch fresh spawned player agents too
- allow per-agent model choice for Run DM and players

## Important conclusion

The problem is **not** in:
- campaign structure
- packet preparation
- runtime reset/snapshot workflow

The problem is in:
- **tool access / orchestration path**

## Current workspace state when this was recorded

- campaign docs updated for runtime-safe episode injection
- `campaigns/test/episode_plan.json` rewritten to avoid mid-run hard resets / teleports / retroactive scene forcing
- active runtime reset and old run archived
- fresh run scaffolded successfully
- actual run launch still blocked until clean spawn tooling is available
