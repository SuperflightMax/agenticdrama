# Campaigns

## What is a campaign

A campaign is a **persistent timeline** for a series of simulation runs in the same environment with the same characters.

## Structure

```
campaigns/
├── TEMPLATE/          ← copy this to start a new campaign
│   ├── world_state.json
│   ├── WORLD.md
│   ├── protocol.md
│   ├── rules.md
│   ├── characters/    ← your character roster
│   └── README.md
└── <campaign_name>/   ← your actual campaign
    ├── world_state.json
    ├── WORLD.md
    ├── protocol.md
    ├── rules.md
    ├── characters/
    ├── turn_log.jsonl
    ├── story_log.md
    └── runs/           ← archived runs
```

## Starting a new campaign

1. Copy `TEMPLATE/` to `campaigns/<name>/`
2. Edit WORLD.md — your environment
3. Pick 2–4 characters from `players/` and copy to `characters/`
4. Fill in backstory, state, relations for each character
5. Update world_state.json
6. Commit to git

## DM workflow

When DM starts a new campaign session:
1. Read `campaigns/<name>/WORLD.md` — understand the environment
2. Read `campaigns/<name>/world_state.json` — current state
3. Read `campaigns/<name>/characters/` — character roster
4. Read `protocol.md` and `rules.md` — follow the rules
5. Consult `sim_archive/scenes/` and `sim_archive/scenarios/` for situation setup

## Runs

Each run goes in `runs/log-YYYY-MM-DD-run-N-description/`
After each run: DM pushes to git.
