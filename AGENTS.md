# AGENTS.md — OpenClaw bootstrap

This file is only for session bootstrap and context reload.
It is not the project brain.
Project meaning, runtime orchestration, and operating rules live in `SOUL.md`, `LAB_OPERATIONS.md`, and `docs/`.

## Session startup

Read in this order:
1. `SOUL.md`
2. `LAB_OPERATIONS.md`
3. `docs/simulation_agents_life_core.md`
4. `docs/LAB_ARCHITECTURE.md`
5. `docs/CAMPAIGN_TEMPLATE_SPEC.md`
6. `docs/RUN_ARTIFACTS_SPEC.md`
7. `docs/RUNTIME_WORKFLOW.md`
8. `docs/EPISODE_SYSTEM.md`
9. `docs/MEMORY_MODEL.md`
10. `docs/system_contract.md`
11. `CONVENTIONS.md`
12. `protocol.md`
13. `rules.md`
14. `episodes/README.md` if it exists

Then inspect active runtime:
15. `campaign/CAMPAIGN.md` if it exists
16. `campaign/WORLD.md` if it exists
17. `campaign/SIMULATION_RULES.md` if it exists
18. `campaign/world_state.json` if it exists
19. `campaign/cast/` if it exists
20. `campaign/run/metadata.json` if it exists
21. `campaign/episode_plan.json` if it exists
22. `campaign/run/episode_state.json` if it exists
23. tail of `campaign/run/story_log.md` if it exists
24. tail of `campaign/run/turn_log.jsonl` if it exists
25. tail of `campaign/run/tick_snapshots.jsonl` if it exists

## After reading

Report explicitly:
- which files were loaded,
- whether an active campaign exists,
- whether active runtime exists,
- whether the active campaign looks launchable,
- whether there is an active run that can be continued,
- if not launchable: what exactly is missing or inconsistent.

Do not silently continue as if the workspace is ready when it is not.

## Reload rule

After restart, trust files over chat memory.
If runtime files disagree, report the mismatch before doing further work.

## Safety

- Do not rewrite runtime history unless explicitly repairing it.
- Prefer append-only behavior for runtime artifacts.
- Do not invent canon to cover gaps.
- Do not ask Run DM to browse the repo. Compile and inject what it needs.
