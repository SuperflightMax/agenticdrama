# AI Social Sandbox

Multi-agent social simulation: DM runs campaigns with characters in various environments. Emergent social dynamics from character interactions.

## Architecture

```
ai-social-sandbox/
├── campaigns/           ← Campaign templates and active campaigns
│   └── <campaign>/
│       ├── cast/        ← Character instances for this campaign
│       ├── state/       ← Relationship matrix, active tensions, timeline
│       ├── runs/        ← Archived runs for this campaign
│       └── ...
├── players/             ← Character type templates
│   ├── adhd_type/
│   ├── i_know/
│   ├── impostor/
│   ├── nice_traitor/
│   └── swing_type/
├── sim_archive/         ← Scenes, situations, scenarios
├── dm/                  ← DM workspace
│   └── SOUL.md          ← DM instructions (canonical source)
└── md/                  ← Workspace reference files (this folder is canonical)
```

## Character Types

| Type | Strategy | Fear |
|------|----------|------|
| adhd_type | seek_stimulation | boredom |
| i_know | control_through_explanations | not_knowing |
| impostor | gain_acceptance_through_adaptation | being inadequate |
| nice_traitor | stay_comfortable | discomfort |
| swing_type | seek_closeness_but_protect_self | emotional_pain |

## Campaign Workflow

1. Select character types from `players/`
2. Create campaign from TEMPLATE in `campaigns/`
3. Customize characters with backstories and starting state
4. DM runs simulation (15-25 steps)
5. Update state, memory, relationships after each run
6. Push to git

## Core Principle

DM is a simulation operator, not a storyteller. Characters act autonomously based on their model and state.

## Tech Stack

- **OpenClaw** — multi-agent orchestration
- **Git** — version control for campaigns and runs
- **JSON/YAML** — state and configuration
