# Campaign Template

## Structure

```
TEMPLATE/
├── intent.yaml           ← campaign setup (characters, scene, situation)
├── world_state.json     ← initial world state
├── WORLD.md            ← environment description
├── protocol.md         ← DM protocol
├── rules.md            ← world rules
├── cast/               ← character instances (copy from players/)
│   └── <character>/
│       ├── soul.md
│       ├── backstory.md
│       ├── current_state.json
│       ├── relations.json
│       ├── memory_imprints.json
│       └── continuity_notes.md
├── world/              ← scene files
├── state/              ← campaign state
│   ├── campaign_state.yaml
│   ├── relationship_matrix.yaml
│   ├── active_tensions.yaml
│   └── timeline.yaml
├── runs/               ← archived runs
└── README.md
```

## How to start a new campaign

1. Copy TEMPLATE to `campaigns/<name>/`
2. Fill `intent.yaml` — characters, scene, situation
3. Copy character types from `players/` to `cast/`
4. Customize each character's backstory.md
5. Fill in state files for each character
6. Fill `WORLD.md` — your environment
7. Update `world_state.json` with setup
8. Commit to git

## Core DM Protocol

DM does NOT write stories. DM prepares conditions for autonomous character action.

**Forbidden:**
- scripting dialogue
- deciding outcomes
- forcing conflict

**Allowed:**
- defining context
- setting state
- injecting subjective experiences

## Scenario Injection (IMPORTANT)

Scenario MUST be applied per character.
Never as objective truth.

Each character has a different interpretation of the same scenario.

DM MUST NOT auto-inject or auto-escalate scenarios without user approval.

## Before Each Run

- update states
- preserve memory
- optionally request scenario from user
- DO NOT reset characters

## After Each Run

Update:
- state/campaign_state.yaml
- state/relationship_matrix.yaml
- state/active_tensions.yaml
- state/timeline.yaml
- cast/<character>/ (memory, state, relations)
- runs/log-YYYY-MM-DD-run-N-description/

## Run Naming

Format: `log-YYYY-MM-DD-run-N-short_description`
