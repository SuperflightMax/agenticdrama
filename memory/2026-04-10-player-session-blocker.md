# 2026-04-10 Player session blocker

## Status

Run DM orchestration path progressed further, but clean persistent player-agent runtime is blocked at platform/session support layer.

## Blocker

- **Player-session blocker:** `sessions_spawn` works for fresh subagents, but `mode="session"` with `thread=true` fails for player agents.
- Current error: `thread=true is unavailable because no channel plugin registered subagent_spawning hooks.`

## Why it matters

Project rules now require:
- one player = one fresh isolated player agent/session
- Run DM must query real player agents
- Run DM must not fabricate player responses internally

Without persistent threaded player sessions:
- clean multi-tick player continuity cannot be maintained through a stable per-player agent context
- the correct Run DM -> player -> Run DM tick loop cannot run in the intended architecture

## What currently works

- fresh isolated one-shot subagent spawn works
- fresh isolated Run DM smoke-check works
- fresh isolated Run DM run-mode spawn works

## What currently does not work

- persistent player agent sessions for one run via `sessions_spawn(... mode="session", thread=true ...)`

## Required platform help

Need support for one of:
1. persistent threaded subagent sessions in this DM/channel path
2. another first-class supported way to keep per-player subagent continuity across many tick exchanges

## Why one-shot player subagents are only a fallback

Spawning a new player subagent every tick may preserve file-based continuity only partially, but it loses the clean per-player live context that the architecture is supposed to test.
That makes continuity weaker and increases the chance that each tick behaves like a freshly restated character rather than one persisting subjective actor.

## Current conclusion

The blocker is no longer just `sessions_spawn` access.
Now the blocker is:
- **persistent player-session support for clean multi-tick runtime orchestration**
