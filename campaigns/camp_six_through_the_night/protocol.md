# protocol.md — Six Through the Night

## DM → player

```json
{
  "tick": 3,
  "perceived_self": {
    "stress": 78,
    "mood": 32,
    "fatigue": 41,
    "health": 89,
    "pain": 12,
    "clarity": 34,
    "mobility": 56
  },
  "world_feel": "слишком открыто, свет режет глаза, сзади будто движение",
  "attention_bias": "взгляд всё время липнет к краю поля и к человеку справа",
  "body_feel": ["сухость во рту", "ноги ватные", "пальцы мёрзнут"],
  "visible_world": ["слева сетка футбольной коробки", "впереди свет заправки", "рядом кто-то тяжело дышит"],
  "heard_or_felt": ["металл скрипнул", "кажется, сзади короткий свист"],
  "social_read": ["тон N звучит как давление", "молчание M кажется подозрительным"],
  "triggered_interpretations": ["может быть, нас уже догоняют"],
  "incoming_messages": [],
  "relations": {},
  "reply_schema": {
    "speech": "array",
    "intent": "object",
    "reasoning_brief": "string"
  }
}
```

## player → DM

```json
{
  "speech": [
    {"to": "group", "text": "туда нельзя"}
  ],
  "intent": {
    "type": "move | observe | take | drop | help | restrain | split | hide | rest | custom",
    "target": "optional object/zone/player id",
    "modifiers": ["optional"]
  },
  "reasoning_brief": "коротко, из текущего восприятия"
}
```

## Notes

- Персонажи не обязаны говорить правду.
- Персонажи не обязаны понимать, что с ними происходит.
- Персонажи могут молчать.
- Персонажи могут действовать из ложной интерпретации.
