# Conventions — AI Social Sandbox

## Language

**Все пользовательские файлы — на русском:**
- story_log.md
- summary.md
- SOUL.md персонажей
- сообщения игрокам

**turn_log.jsonl** — технический, English keys, mixed content.

## Story Log Formatting

В story_log.md:
- **ID → имя** соответствие пишется ОДИН раз в начале файла, в одну строку
- В тексте используются ТОЛЬКО имена, без ID в скобках
- Таблица состояния тоже только имена, без ID

## Logging — Run Files

Каждый прогон создаёт папку:
```
runs/log-YYYY-MM-DD-run-N-name/
├── metadata.json        # название, дата, тики
├── story_log.md        # нарратив на русском
├── summary.md          # итоги на русском
├── turn_log.jsonl     # полный лог тиков
├── tick_snapshots.jsonl # состояние мира на каждом тике
└── world_state_end.json # финальный world_state
```

## turn_log.jsonl Format

Каждая запись — один JSON объект, одна строка.

**Типы событий:**

```json
{"tick": N, "event_type": "tick_started", ...}
{"tick": N, "event_type": "dm_query", "queries": [{player, perceived_self, world_feel, attention_bias, body_feel, visible_world, heard_or_felt, social_read, triggered_interpretations, incoming_messages, relations, reply_schema}, ...]}
{"tick": N, "event_type": "player_response", "responses": [{player, speech: [{to, text}], intent: {type, target, modifiers}, reasoning_brief}, ...]}
{"tick": N, "event_type": "movement", "actors": [...], "from": "zone", "to": "zone", ...}
{"tick": N, "event_type": "zone_entered", "zone": "...", "actors": [...], ...}
{"tick": N, "event_type": "speech", "actor": "pX", "text": "...", "visibility": [...], ...}
{"tick": N, "event_type": "tick_completed", ...}
```

**dm_query → player_response** пары обязательны для значимых тиков.

## tick_snapshots.jsonl Format

По одной записи на тик (tick 0 → N):
```json
{"tick": N, "zone": "...", "lighting": "...", "temperature": "...", "note": "...", "players": {"p1": {"zone": "...", "stress": N, "mood": N, "fatigue": N, "health": N, "pain": N, "clarity": N, "mobility": N}, ...}, "speech": ["actor: text"]}
```

## Run Naming

Формат: `log-YYYY-MM-DD-run-N-name`
- N — порядковый номер прогона за день
- name — короткое описание (snake_case)

## Git

После каждого прогона:
```bash
git add runs/log-.../
git commit -m "Run N: description"
git push
```

## Campaign vs Runs

- **campaign/** — активная кампания (текущий прогон в процессе)
- **campaigns/camp_NAME/** — все кампании (архив)
- **runs/** — отдельные прогоны со всеми логами
