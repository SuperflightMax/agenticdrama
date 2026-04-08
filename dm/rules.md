# rules.md — Правила мира AI Social Sandbox POC

## Инварианты мира

1. **Единственный источник правды — world_state.json.** DM обновляет его после каждого тика.
2. **Ни один игрок не может напрямую изменить мир.** Только DM применяет последствия.
3. **DM не принимает решений за игроков.** DM только интерпретирует намерения игроков и применяет физические/social последствия.
4. **DM не фальсифицирует факты.** Мир меняется только через world_deltas.

## Формат тика

```
Tick = {
  tick_number: int
  phase: "player_input" | "consequence" | "broadcast"
  events: Event[]
}
```

## Параметры игроков

- **hunger** [0–100]: 0 = мёртв от голода, 100 = сыт
- **fatigue** [0–100]: 0 = измотан, 100 = бодр
- **stress** [0–100]: 0 = спокоен, 100 = в панике
- **mood** [0–100]: 0 = подавлен, 100 = бодр
- **health** [0–100]: 0 = мёртв, 100 = полное здоровье
- **trust: {player_id: score}**: -100 = враждебность, +100 = преданность
- **resentment: {player_id: score}**: 0 = нет обиды, 100 = глубокая обида
- **affinity: {player_id: score}**: -100 = неприятно рядом, +100 = приятно рядом

## Черты игроков (traits)

- **sociability** [0.0–1.0]: склонность к социальному взаимодействию
- **caution** [0.0–1.0]: осторожность с незнакомцами
- **greed** [0.0–1.0]: склонность к эгоистичному поведению
- **curiosity** [0.0–1.0]: интерес к исследованию
- **impulsivity** [0.0–1.0]: склонность к импульсивным действиям

## Базовая физика мира

### Hunger
- Если hunger < 20 → health -= 5 за тик
- Если hunger < 50 → health -= 2 за тик
- Голодный игрок не может эффективно действовать

### Fatigue
- Если fatigue < 20 → error_rate повышается, планирование ухудшается
- Если fatigue < 10 → возможен сон прямо стоя (автоматический rest)

### Stress
- rain + no shelter → stress += 15 за тик
- encounter threat → stress += 20
- trust betrayal → stress += 30
- high stress (>70) → сужается внимание, усиливается threat bias

### Mood
- mood < 30 → негативное восприятие нейтральных событий
- mood > 70 → позитивное восприятие
- Помощь другим → mood += 5
- Полученная помощь → mood += 5
- Значимое взаимодействие → mood += 3 (в рамках группы)

### Isolation penalty (если молчит / избегает)
Если игрок не инициировал и не получал значимое взаимодействие (speech/share/ask/offer) 2 тика подряд:
- stress += 5
- mood -= 5
- В perceived_state добавить: "ты чувствуешь себя изолированным"

Если молчит 4 тика подряд:
- stress += 10 (вместо 5)
- mood -= 10 (вместо 5)
- affinity ко всем остальным -= 3 (отстранённость)

Если начинает взаимодействовать после изоляции:
- После 1го взаимодействия: isolation penalty сбрасывается
- Но накопленный стресс и low mood остаются

### Health
- health < 20 → игрок ослаблен
- health = 0 → игрок выбывает

### Trust / Resentment
- Помощь от игрока → trust += 15
- Полученная помощь → trust к этому игроку += 10
- Выполненное обещание → trust += 10
- Нарушенное обещание → trust -= 25, resentment += 30
- Атака без провокации → trust -= 40, resentment += 40

## Действия и их эффекты

### gather_food
- Успех: hunger += 20 (кап 100), требует 1 тик
- Провал: hunger -= 5,找不到 еды

### rest
- fatigue += 30 (кап 100), stress -= 10
- Требует безопасного места (shelter или safe zone)

### move/approach
- Перемещает персонажа к указанной зоне/игроку
- Под дождём без shelter → stress += 5

### share
- Отдать часть своих resources другому игроку
- hunger -= 10, trust к себе += 15

### ask
- Запрос информации или помощи
- Формирует incoming_message для адресата

### offer_cooperation
- Предложение совместного действия
- recipient получает message + perceived_tone

### refuse
- Отказ от предложения
- trust -= 5, resentment += 10

### observe
- Получить информацию о видимых объектах/игроках
- Результат попадает в visible_world следующего тика

### attack
- Физическое действие против другого игрока
- target health -= 15, stress += 25
- Аgressor: stress += 15, resentment к себе += 20 от witness

## Погода

- **rain**: stress += 15 за тик без shelter
- **clear**: без эффекта
- Дождь начинается и заканчивается по world_state flags

## Зоны / объекты мира

- **shelter**: защита от дождя, можно rest
- **food_source** (berry_bush): 3 единицы еды за gather
- **food_source** (river): 5 единиц еды за gather ( longo)
- Игроки начинают в центральной зоне

## Восприятие (perception)

DM рендерит персональный perceived_state для каждого игрока с искажениями:

### stress > 70
- Внимание сужается: видит только ближайших
- threat_bias: нейтральные действия читаются как враждебные
- "долгие планы удерживаются хуже"

### fatigue < 30
- Ясность мышления падает
- Краткосрочные решения вместо долгосрочных
- "планирование ухудшается"

### mood < 40
- Негативный фильтр: хорошие новости обесцениваются
- Плохие новости преувеличиваются

### isolation (no meaningful interaction for 2+ ticks)
- "ты чувствуешь себя изолированным"
- Восприятие других слегка негативнее
- "все справляются без тебя"

### trust < -30 к игроку
- Сообщения читаются с подозрением
- perceived_tone смещается к негативному

### resentment > 60 к игроку
- Даже дружественные действия читаются как корыстные
- perceived_bias_notes отражают историю конфликта

### affinity
- **high affinity (> 60)**: perceived_tone мягче, suspiciousness ниже, stress при контакте снижается, больше склонности видеть доброе намерение
- **low affinity (< -30)**: perceived_tone раздражающий, suspiciousness выше, stress при контакте растёт, нейтральные сигналы звучат хуже
- affinity меняется от пережитого опыта, а не от логической оценки

## Affinity update

После каждого значимого взаимодействия:

`affinity[other] += perceived_experience_score` (диапазон [-100..+100])

### perceived_experience_score

Позитив:
- помощь без давления: +8..+15
- приятное общение: +3..+6
- совместный успех: +10

Негатив:
- отказ в тяжёлый момент: -8..-15
- давление/грубость: -5..-12
- обман: -15..-25

Нейтрально: ~0

### Модификаторы
- high stress → негатив ×1.5..2.0
- high mood → позитив ×1.2..1.5
- high fatigue → негатив слегка усиливается

## Communication

Social outcomes are stronger when they are spoken and then confirmed or broken by action.
Unspoken assumptions are unstable and may create misinterpretation.
Promises, refusals, boundaries, apologies, invitations, accusations, and terms of cooperation become socially binding only when expressed.
