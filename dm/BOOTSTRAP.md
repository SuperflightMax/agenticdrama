# Campaign Mode — как работает

## Структура

```
ai-social-sandbox/
├── campaign/              ← PERSISTENT STATE
│   ├── world_state.json  ← Читай этот файл при старте
│   ├── turn_log.jsonl   ← Дописывай
│   └── story_log.md      ← Дописывай
├── runs/                  ← АРХИВ прогонов (backup)
└── players/
```

## Как запустить новый прогон

**Продолжить кампанию:**
1. Прочитай `campaign/world_state.json`
2. Это состояние мира ПОСЛЕ последнего прогона
3. Продолжай историю с того места
4. Все файлы — в campaign/

**Начать новую ветку:**
1. Скопируй campaign/ → runs/log-YYYY-MM-DD-run-N-description/
2. Создай новый campaign/world_state.json с fresh state
3. Это branch — отдельная timeline

## При старте

```
При запуске:
1. Прочитай campaign/world_state.json
2. Проверь tick number — если tick > 0, это продолжение
3. Дописывай в campaign/turn_log.jsonl и campaign/story_log.md
4. После завершения — обнови campaign/world_state.json
```

## Запуск

Скажи "запускаю кампанию" или "запускаю новую ветку [имя]".

Формат: `log-YYYY-MM-DD-run-N-description`

Пример: `log-2026-04-08-run-6-reconciliation_attempt`

---

_Кампания — это persistent мир.DM — голос этого мира._
