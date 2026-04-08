# Campaign Template

## How to start a new campaign

1. Copy this TEMPLATE folder to `campaigns/<your_campaign_name>/`
2. Fill in WORLD.md — describe your environment
3. Select characters from `players/` folder
4. Copy selected characters to `characters/` subfolder
5. Customize each character's backstory.md
6. Initialize current_state.json, relations.json for each character
7. Update world_state.json with character roster
8. Update this README with campaign specifics

## Character setup

Each character in `characters/` needs:
- soul.md — character type and behavior
- backstory.md — name, age, appearance, history
- current_state.json — starting parameters
- relations.json — starting relationships
- memory_imprints.json — initial memories (usually empty)
- continuity_notes.md — initial inner state

## Run naming

Format: `log-YYYY-MM-DD-run-N-short_description`

Example: `log-2026-04-08-run-1-morning_conflict`
