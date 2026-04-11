# SESSION_MEMORY_2026-04-10 — что произошло и что с этим делать

## Что было сделано сегодня

### 1. Архитектура агентов — исправлена
- Раньше Rundm создавался через `sessions_spawn`, что было неправильно и давало ему subagent, не persistent agent
- Теперь Rundm и runplayerXX — это **постоянные агенты**, которые работают через `sessions_send` напрямую
- `sessions_spawn` для нормальных ран **больше не нужен**
- `rundm` пишет в общий runtime через symlink: `workspace-rundm/campaign -> /home/sf/.openclaw/ai-social-sandbox/campaign`

### 2. Bootstrap как repo-backed source of truth
- Исходники: `runtime_agents/rundm/` и `runtime_agents/runplayer/`
- Синк: `scripts/sync_runtime_agent_bootstraps.sh`
- Рабочий процесс: правим в repo → запускаем sync → запускаем ран
- Живые workspace-файлы агентов — это копии из repo

### 3. State Model — почти переписана
Основные добавленные концепции:
- Normalized semantics: числа должны значить одно и то же у разных персонажей
- Character-local modifiers НЕ меняют значение числа, только response curve
- Non-linear bands: влияние нелинейно, near-top bands steepens
- Foreground capture: очень высокие значения не просто bias, а dominance
- Slow vs fast fields distinction: не все поля меняются с одной скоростью
- Buffer/compensator collapse ≠ raw pressure increase
- Memory-triggered fast state reinstatement
- Acute survival mode: не только "тигр бежит", но и collapse жизненной опоры
- anticipatory_dread / future insecurity как отдельный механизм
- Dynamic salience: один pool состояний, разная foreground в разных ситуациях

### 4. Граница math vs DM interpretation
- Math даёт ground, не заменяет интерпретацию
- Не "math сама всё решает", не "DM выдумывает с нуля"
- Хорошее правило: если эффект выводится из общей модели — не добавляй сущность

### 5. Что НЕ было сделано
- RELATION_MODEL.md — нужен, но не срочный; те же принципы что в STATE_MODEL
- UPDATE_RULES.md — нужен, но не срочный; то же что мы обсуждали для state

## Как запускать ран

### Активировать campaign и создать ран:
```bash
cd /home/sf/.openclaw/ai-social-sandbox
bash scripts/runtime_ops.sh activate test  # или test_minimal
bash scripts/runtime_ops.sh new-run --run-id my_run_name
```

### Запустить Rundm:
```bash
# Используем sessions_send напрямую, НЕ sessions_spawn
# run-scoped session key:
#   agent:rundm:run:<run_id>:rundm

# Пример (внутри этой сессии):
sessions_send sessionKey="agent:rundm:run:my_run_name:rundm" message="Run my_run_name now..." timeout=300
```

### Player sessions:
- `agent:runplayer01:run:<run_id>:player:01` — Anya
- `agent:runplayer02:run:<run_id>:player:02` — Nikita
- `agent:runplayer03:run:<run_id>:player:03` — Rita

### Fresh run-scoped sessions могут отвечать медленно (cold-start)
Не считать первый timeout за провал.

## Что добавить в промпты Rundm (и в bootstrap)

### Обязательно:
1. Эта память (SESSION_MEMORY) — он должен знать про architecture decisions
2. State Model как reference он может читать из docs/STATE_MODEL.md
3. Memory Model: docs/MEMORY_MODEL.md
4. System Contract: docs/system_contract.md

### Чего НЕ делать:
- Не создавать ран через spawn
- Не давать игрокам raw memory storage
- Не писать в private workspace-папки мимо symlink
- Не слать игрокам prose вместо JSON

## Если сессия перезапустилась

При запуске Lab DM должен:
1. Прочитать SOUL.md, LAB_OPERATIONS.md
2. Проверить campaign/run/ и session store
3. Сказать: какой campaign, какой run, на каком этапе
4. Восстановить контекст из этой памяти если нужно

## Если Rundm забыл про архитектуру

Ему в message или в bootstrap напоминать:
- "Ты persistent agent, не subagent"
- "Пиши в campaign/ который через symlink"
- "Общайся с players через sessions_send"
- "Players отвечают JSON, ты шлёшь JSON packets"

## Конкретные скрипты

- `scripts/runtime_ops.sh` — активация, new-run, snapshot, restore
- `scripts/sync_runtime_agent_bootstraps.sh` — синк bootstrap из repo в live workspaces

## Главные файлы проекта сейчас

- `docs/STATE_MODEL.md` — state semantics, bands, update rules, boundary math/DM
- `docs/MEMORY_MODEL.md` — memory formation, activation, reinstatement
- `docs/system_contract.md` — суть проекта, что моделируем
- `runtime_agents/rundm/` — Rundm bootstrap
- `runtime_agents/runplayer/` — player bootstrap (общий для 01-06)
- `campaign/` — активный runtime
- `campaigns/<name>/` — хранилище campaign
