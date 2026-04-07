# Agentic Drama — AI Social Sandbox POC

Multi-agent social simulation: one DM + multiple player agents running in a shared world with emergent social dynamics.

## Architecture

```
agenticdrama/
├── dm/                    # DM (Dungeon Master) agent workspace
│   ├── AGENTS.md
│   ├── BOOTSTRAP.md
│   ├── IDENTITY.md
│   ├── SOUL.md            # DM role & responsibilities
│   ├── USER.md
│   ├── TOOLS.md
│   ├── HEARTBEAT.md
│   ├── rules.md           # World physics & perception distortion rules
│   ├── protocol.md        # JSON exchange formats
│   ├── world_state.json   # Current ground-truth world state
│   ├── turn_log.jsonl     # Event log (one line per event)
│   └── dm-runner.js       # Optional Node.js game loop runner
├── players/               # Player agent workspaces
│   ├── player_1/
│   │   ├── AGENTS.md, BOOTSTRAP.md, IDENTITY.md, SOUL.md, USER.md, TOOLS.md, HEARTBEAT.md
│   ├── player_2/
│   │   └── ...
│   └── player_3/
│       └── ...
└── README.md
```

## Core Concepts

- **DM (Dungeon Master)**: single source of world truth. Renders personal perceived_state for each player with distortions based on their stress/fatigue/mood/trust/affinity state. Does NOT decide for players.
- **Players**: autonomous agents. Each receives a personalized world view, decides their own actions, sends speech + intent back to DM.
- **Affinity system**: emotional valence axis (separate from trust/resentment). Determines how pleasant/unpleasant interactions feel. Changes from lived experience, not logic.
- **Communication via DM**: players never talk to each other directly — all messages go through DM who routes them with perceived_tone + bias notes.

## Player Personalities

| Player | Traits | Archetype |
|--------|---------|-----------|
| player_1 | cooperative, social, medium caution | Team builder |
| player_2 | calculating, opportunistic, polite | Strategic egoist |
| player_3 | suspicious, revengeful, independent | Wary lone wolf |

## Relation Axes

Each player tracks three relationship axes toward every other player:

- **trust** — reliability (can you count on them?)
- **resentment** — accumulated grievance
- **affinity** — emotional pleasantness of interaction (do you enjoy being around them?)

## Tech Stack

- **OpenClaw** — multi-agent orchestration
- **sessions_send** — DM-to-player communication
- **JSON** — world state & event log
- Filesystem as ground truth (world_state.json + turn_log.jsonl)

## Usage

DM connects to players via `sessions_send`. Each tick:

1. DM reads world_state.json
2. Renders perceived_state for each player (with distortions)
3. Sends tick packet to each player via sessions_send
4. Collects player responses (speech + intent)
5. Applies consequences to world_state
6. Updates affinity based on perceived_experience_score
7. Logs events to turn_log.jsonl
8. Repeat

## POC Status

✅ 10-tick runs working  
✅ Affinity system implemented  
✅ Trust/resentment/affinity tracked per player pair  
✅ Per-player perception distortions  
⏳ Threat/encounter system (planned)

---

Built as a POC for multi-agent social simulation with emergent behavior.
