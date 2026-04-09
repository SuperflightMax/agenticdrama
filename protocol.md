# protocol.md — DM ↔ player data exchange

This file defines the exchange contract between Run DM and player agents.
It does **not** define campaign-specific mechanics. Those belong in `campaign/SIMULATION_RULES.md`.

## 1. Core principle

Run DM sends each player a **subjective slice**, not omniscient truth.
Players return a bounded structured response.

Run DM must not:
- equalize information between characters,
- reveal what a character failed to notice,
- replace a player's decision with a narrative convenience.

## 2. Player → Run DM (`player_response`)

```json
{
  "speech": [
    {
      "to": "player_2 | group",
      "text": "message text"
    }
  ],
  "intent": {
    "type": "move | observe | take | drop | help | restrain | split | hide | rest | attack | custom",
    "target": "optional object / zone / player id",
    "modifiers": ["optional"]
  },
  "reasoning_brief": "short reason from the character's current subjective state"
}
```

### Notes
- `speech` may be empty.
- `intent.type = custom` is allowed when campaign rules support something outside the baseline list.
- `reasoning_brief` should stay short and subjective.

## 3. Run DM → player (`perceived_state`)

```json
{
  "tick": 5,
  "perceived_self": {
    "stress": 78,
    "mood": 32,
    "fatigue": 41,
    "health": 89,
    "pain": 12,
    "clarity": 34,
    "mobility": 56
  },
  "world_feel": "one or two sentences of subjective environmental feel",
  "attention_bias": {
    "focused_on": ["what strongly catches attention"],
    "ignored": ["what drops out of focus"]
  },
  "body_feel": ["dry mouth", "heavy legs", "cold hands"],
  "visible_world": ["what is seen"],
  "heard_or_felt": ["what is heard or otherwise sensed"],
  "social_read": ["subjective reading of others"],
  "memory_effects": ["unease around p2", "familiar safety near the shelter"],
  "triggered_interpretations": ["maybe they are hiding something"],
  "action_pulls": ["move away", "press for an answer", "stay close to the light"],
  "incoming_messages": [
    {
      "from": "player_2",
      "text": "actual message text",
      "perceived_tone": "how it lands for this receiver",
      "perceived_bias_notes": ["why it lands that way"]
    }
  ],
  "relations": {
    "player_2": {
      "trust": 10,
      "resentment": 45,
      "affinity": -20
    }
  },
  "reply_schema": {
    "speech": "array",
    "intent": "object",
    "reasoning_brief": "string"
  }
}
```

## 4. Perceived-state field intent

### `perceived_self`
Current body / mind parameters as subjectively relevant to this campaign.

### `world_feel`
A subjective environmental feel, not a neutral camera description.

### `attention_bias`
What is salient and what falls out of attention in this state.

### `social_read`
How others are being read through current state, memory, and relation biases.
This may be wrong.

### `memory_effects`
Triggered familiarity, tension, comfort, dread, trust-like ease, suspicion, or similar memory-driven influences.
Do not dump archival memory here.

### `triggered_interpretations`
Fast subjective conclusions or emotionally loaded readings.
These are not objective truth.

### `action_pulls`
Action tendencies that arise from the state and appraisal.
They are not final decisions.

## 5. Internal runtime events

`turn_log.jsonl` may contain events such as:
- `tick_started`
- `dm_query`
- `player_response`
- `movement`
- `zone_entered`
- `speech`
- `resource_changed`
- `state_changed`
- `memory_updated`
- `world_updated`
- `tick_completed`

Detailed writing rules and examples are defined in `docs/RUN_ARTIFACTS_SPEC.md`.
