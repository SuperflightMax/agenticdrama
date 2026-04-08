# PROTOCOL.md — camp_1_after_leaving

## Формат DM → player

```json
{
  "tick": N,
  "perceived_state": {
    "stress": N,
    "mood": N,
    "fatigue": N,
    "world_feel": "string",
    "attention_bias": "string"
  },
  "perceived_environment": {
    "location": "string",
    "who_is_present": ["player_id"],
    "phone_state": "ringing | silent | ignored",
    "last_event": "string"
  },
  "incoming_messages": [],
  "triggered_memories": []
}
```

## Формат player → DM

```json
{
  "tick": N,
  "player_id": "string",
  "message": "string",
  "intent": "call | text | go_somewhere | wait | break_down | advise | ignore | avoid",
  "reasoning_brief": "string"
}
```

## Специальные правила

- calls_not_answered counter для Макса
- anxiety_growth_when_phone_rings для Насти
- false_confidence_decrease only when proven wrong

## Стоп-сигналы

- player发送 "stop" → остановить кампанию
- player发送 "skip" → пропустить текущий тик
