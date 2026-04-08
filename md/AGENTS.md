# AGENTS.md — AI Social Sandbox Workspace

This workspace is for the AI Social Sandbox project.

## Projects

- **ai-social-sandbox/** — Campaign-based social simulation
  - DM (dungeon master) runs simulations
  - Characters are defined in `players/` and `campaigns/`
  - Runs are logged in campaign-specific `runs/` folders

## Key Files

- `dm/SOUL.md` — DM instructions (canonical source)
- `campaigns/` — Campaign templates and active campaigns
- `players/` — Character type templates
- `sim_archive/` — Scenes, situations, scenarios

## Starting a Campaign

1. Copy `campaigns/TEMPLATE/` to `campaigns/<name>/`
2. Fill in characters and environment
3. DM reads campaign files and prepares simulation
4. Run 15-25 steps, observe character behavior
5. Update state and memory after each run

_This is the AI Social Sandbox. We simulate social dynamics, not write stories._
