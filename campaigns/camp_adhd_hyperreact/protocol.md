# PROTOCOL.md — camp_adhd_hyperreact

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
    "visible_objects": ["object_id"],
    "last_event": "string"
  },
  "incoming_messages": [
    {
      "from": "player_id",
      "content": "string",
      "perceived_tone": "string"
    }
  ],
  "triggered_memories": [
    {
      "imprint_id": "string",
      "cue_match": "string",
      "felt_as": "string"
    }
  ]
}
```

## Формат player → DM

```json
{
  "tick": N,
  "player_id": "string",
  "message": "string (что говорит)",
  "intent": "clarify | pressure | retreat | provoke | smooth | wait | escape",
  "reasoning_brief": "string (короткое)"
}
```

## Правила применения

1. После получения всех player_responses:
   - применить последствия каждого intent к world_state
   - симулировать NPCs которые не получили внешних сообщений
   - обновить world_state
   - записать в tick_snapshots.jsonl
   - записать в turn_log.jsonl
   - записать в story_log.md

2. После завершения любого run:
   - сохранить всё в runs/
   - запушить

## Специальные события

Если Настя уходит из квартиры → сценарий переходит в next_scenario_injection (по команде пользователя).

## Стоп-сигналы

- player发送 "stop" → остановить кампанию
- player发送 "skip" → пропустить текущий тик
