# protocol.md — Форматы обмена данными (DM ↔ игроки)

## Общий принцип

DM не подсказывает и не выравнивает информацию.
Каждый игрок получает только свой субъективный срез.
DM не сообщает что игрок пропустил — только то что попало в фокус.

---

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
    "type": "move | observe | take | drop | help | restrain | split | hide | rest | attack | custom",
    "target": "optional object/zone/player id",
    "modifiers": ["optional"]
  },
  "reasoning_brief": "короткое обоснование из текущего восприятия"
}
```

### speech[]
Массив исходящих сообщений. `to` — id получателя (другой игрок, "group", или пусто для молчания).

### intent
Конкретные типы определяются кампанией. Общие классы:
- `move` — перемещение
- `observe` — внимание к объекту/зоне/игроку
- `take` / `drop` — работа с предметом
- `help` / `restrain` — действия с другими игроками
- `split` — разделение группы
- `hide` — укрытие
- `rest` — отдых
- `attack` — физическое действие
- `custom` — иное

---

## DM → Агент-игрок (perceived_state)

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
  "world_feel": "описание ощущения среды одним предложением",
  "attention_bias": {
    "focused_on": ["список того что цепляет внимание"],
    "ignored": ["список того что игнорируется"]
  },
  "body_feel": ["сухость во рту", "ноги ватные", "холодно"],
  "visible_world": ["что видит", "контуры", "движение"],
  "heard_or_felt": ["что слышит", "вибрация", "звук"],
  "social_read": ["интерпретация тонов и поведения других"],
  "triggered_interpretations": ["автоматические выводы которые возникают"],
  "incoming_messages": [],
  "relations": {},
  "reply_schema": {
    "speech": "array",
    "intent": "object",
    "reasoning_brief": "string"
  }
}
```

### perceived_self
Параметры состояния. Конкретный набор определяется кампанией, но обычно включает stress, mood, fatigue, health.

### world_feel
Одно-два предложения: общее ощущение среды, не нейтральное описание.

### attention_bias
Что цепляет взгляд и что игнорируется — с точки зрения состояния.

### body_feel
Телесные ощущения в данный момент.

### visible_world / heard_or_felt
Сенсорный срез мира. Не полный — только то что попало.

### social_read
Интерпретация поведения других. Уже с искажениями.

### triggered_interpretations
Автоматические выводы без доказательств: "может быть они уже рядом", "он что-то скрывает".

### incoming_messages
Входящие сообщения от других игроков с DM-проставленными:
- `perceived_tone`: как игрок воспринимает тон
- `perceived_bias_notes`: почему воспринимается именно так

### relations
trust / resentment / affinity к каждому другому игроку.

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
    "intent_type": "move",
    "target_zone": "zone_3",
    "success": true
  },
  "world_deltas": {
    "player_1": { "position": "zone_3" },
    "player_2": { "position": "zone_3" }
  }
}
```

### event_type variants
- `tick_started`
- `message_sent`
- `intent_applied`
- `perception_rendered`
- `world_updated`
- `tick_completed`

### visibility
Кто из игроков видел событие.