# Campaign: Baseline Run

## Что это

Это persistent campaign state. Каждый запуск (run) продолжает историю с того места где закончилась.

## Структура

```
campaign/
├── world_state.json   ← PERSISTENT. Не ресетим между прогонами.
├── turn_log.jsonl    ← Продолжает писаться
├── story_log.md       ← Продолжает писаться
└── metadata.json      ← История прогонов
```

## Как работает

**Продолжить кампанию:**
- DM читает campaign/world_state.json (он содержит текущее состояние группы)
- Продолжает с того места где остановились
- p3 всё ещё resentful к p2 после broken promise
- turn_log/story_log дописываются

**Начать новую ветку (branch):**
- Скопировать campaign/ → runs/run_NAME/ как backup
- Создать новый world_state.json с нуля
- Это отдельная timeline — не влияет на основную кампанию

## История прогонов

| Run | Дата | Событие |
|-----|------|---------|
| 1 | 2026-04-07 | Baseline (clear) — кооперация, все выжили |
| 2 | 2026-04-07 | Rain — давление среды, triangle formed |
| 3 | 2026-04-07 | Clear sky — ровный прогон без драмы |
| 4 | 2026-04-07 | Rain conflict — p3's arc, p2's emotional choice |
| 5 | 2026-04-07 | Broken Promise — p2 нарушил обещание, p3 ушёл, группа раскололась |

## Текущее состояние (после Run 5)

```
p1: с p2, guilt от принятия чужой еды
p2: пара с p1, trust сломан к p3
p3: solo, resentful, не доверяет p2, помнит broken promise
```

## Как запустить Run 6

DM читает campaign/world_state.json и продолжает.
