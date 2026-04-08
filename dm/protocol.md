# protocol.md — Форматы обмена данными

## Агент-игрок → DM (player_response)

```json
{
  "speech": [
    {
      "to": "player_2",
      "text": "текст сообщения"
    }
  ],
  "intent": {
    "type": "gather_food",
    "target": "berry_bush_1",
    "modifiers": ["if_safe"]
  },
  "reasoning_brief": "краткое обоснование"
}
```

### speech[]
Массив исходящих сообщений. `to` — id получателя (другой игрок).
Пустой массив если игрок молчит.

### intent
- `type`: one of `gather_food`, `rest`, `move`, `approach`, `share`, `ask`, `offer_cooperation`, `refuse`, `observe`, `attack`, `custom`
- `target`: optional, id объекта или игрока
- `modifiers`: optional string[]

### reasoning_brief
Короткая строка с объяснением выбора (1-2 предложения).

---

## DM → Агент-игрок (perceived_state)

```json
{
  "tick": 5,
  "self_state": {
    "hunger": 61,
    "fatigue": 34,
    "stress": 70,
    "mood": 28,
    "health": 85
  },
  "traits": {
    "sociability": 0.7,
    "caution": 0.5,
    "greed": 0.4,
    "curiosity": 0.8,
    "impulsivity": 0.6
  },
  "visible_world": [
    "рядом куст с ягодами",
    "идёт дождь",
    "рядом Петя"
  ],
  "incoming_messages": [
    {
      "from": "player_2",
      "raw_text": "давай собирать еду вместе",
      "perceived_tone": "слегка корыстный",
      "perceived_bias_notes": [
        "из-за высокого стресса предложение кажется менее бескорыстным",
        "долгие планы удерживаются хуже"
      ]
    }
  ],
  "memory_highlights": [
    "player_2 однажды не выполнил обещание",
    "player_3 недавно помог тебе"
  ],
  "reply_schema": {
    "speech": "array",
    "intent": "object",
    "reasoning_brief": "string"
  }
}
```

### self_state
Текущие параметры игрока (из world_state на момент отправки).

### traits
Характер игрока (статичные черты).

### visible_world
Список того, что игрок видит вокруг себя. DM рендерит это с учётом позиции и искажений.

### incoming_messages
Массив входящих сообщений от других игроков. Каждое дополнено полями DM:
- `perceived_tone`: как игрок воспринимает тон (friendly/cold/opportunistic/threatening)
- `perceived_bias_notes`: массив строк с объяснением искажений

### memory_highlights
Короткие напоминания из истории взаимодействий (trust/resentment history).

### memory_imprints
Опциональные поля для human-like memory:
```json
"memory_imprints": {
  "triggered_feelings": ["This feels uncomfortably familiar.", "You do not clearly remember why, but you do not like this setup."],
  "familiar_tension": "Something in this interaction resembles an earlier bad turn with p2.",
  "vague_comfort": null,
  "memory_echo": [],
  "explicit_recall": []
}
```
По умолчанию используй feeling / evaluation / echo,
а не explicit recall.

### relations
Три оси отношений к каждому другому игроку:
```json
"relations": {
  "player_2": {
    "trust": 25,
    "resentment": 0,
    "affinity": 18
  }
}
```
- **trust** — надёжность (можно ли положиться)
- **resentment** — накопленная обида
- **affinity** — приятно/неприятно взаимодействовать

### reply_schema
Подсказка для агента о формате ответа.

---

## Внутренний формат: turn_log.jsonl

```json
{
  "tick": 3,
  "event_type": "intent_applied",
  "actor": "player_2",
  "targets": ["player_1"],
  "visibility": ["player_1", "player_2"],
  "data": {
    "intent_type": "share",
    "resource": "food",
    "amount": 10
  },
  "world_deltas": {
    "player_1": { "hunger": -10, "trust_player_2": +15 },
    "player_2": { "hunger": +20 }
  }
}
```

### event_type variants
- `tick_started`: начало тика
- `message_sent`: сообщение отправлено
- `intent_applied`: намерение игрока применено
- `perception_rendered`: восприятие отрендерено для игрока
- `world_updated`: мир обновлён
- `tick_completed`: тик завершён

### visibility
Массив игроков, которым это событие видно (для лога).
