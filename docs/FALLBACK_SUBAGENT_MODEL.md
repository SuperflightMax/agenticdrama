# Fallback subagent model (postal model)

**Status:** temporary workaround, valid under lab integrity constraints  
**When to use:** when persistent threaded subagent sessions are not available  
**Goal:** maintain Run DM / player separation without role collapse

## The problem

- `sessions_spawn(mode="session", thread=true)` is blocked for persistent player sessions
- one-shot subagents die after their task completes
- one-shot Run DM cannot receive player responses for ticks 2+ if those players are already dead
- Run DM simulating players is forbidden by lab rules

## The postal model

Lab DM acts as **orchestration router** ("postal service") between dead-end one-shot agents.

```
Lab DM
  → spawn one-shot Run DM (tick N requests)
  → Run DM dies after returning player queries
  → Lab DM spawns player subagents one by one
  → each player dies after returning response
  → Lab DM spawns next one-shot Run DM with all player responses
  → repeat
```

Lab DM does NOT make decisions. It only:
- routes player queries to player subagents
- routes responses back to Run DM
- maintains artifact continuity between spawns

## What Lab DM must NOT do

- read files for Run DM (that's Run DM's job if it were persistent)
- make causal decisions on behalf of characters
- insert "expected" behavior into player responses

## Pre-compiled task packets

To reduce overhead, Lab DM should pre-compile task packets before spawning:

### DM packet contents (pre-compiled):
- distilled rules (not file references)
- current world_state (already in packet)
- current episode state
- relevant cast data (already in packet)
- explicit instruction: what tick to do, what to return

### Player packet contents (pre-compiled per character):
- soul
- current_state
- relations
- memory_imprints
- continuity_notes
- current subjective packet from Run DM query

## Storage between ticks

Lab DM should maintain:
- `campaign/run/world_state.json` (updated by Run DM)
- `campaign/run/turn_log.jsonl` (appended by Run DM)
- `campaign/run/tick_snapshots.jsonl` (appended by Run DM)
- `campaign/run/story_log.md` (appended by Run DM)
- `campaign/run/episode_state.json` (updated by Lab DM between ticks)

## Optimization notes

- Pre-compile packets instead of referencing files in task text
- Store compiled packet templates for reuse across tick spawns
- For players: store per-character base card with all static data
- Only inject dynamic data (player queries, world state delta) per spawn
- This reduces token overhead and removes file-read dependency from subagent

## Future

When `mode="session" + thread=true` becomes available via proper channel plugin hooks, this model should be replaced by proper persistent player sessions.

## Validity

This model is valid because:
- Run DM never simulates players
- player responses come from real spawned agents
- Lab DM only routes, does not decide
- continuity is maintained through artifacts between tick spawns
