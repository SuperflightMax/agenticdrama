# MEMORY_MODEL.md — memory and state-driven activation

This document defines what memory stores, how imprints form, how they activate,
and how memory affects appraisal and state.

Use together with:
- `docs/simulation_agents_life_core.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/UPDATE_RULES.md`

## 1. Human-like memory

Player memory is not a full archive of events.
It forms automatically from state and state change.
A player cannot reliably decide to remember something just by will.
Strong or prolonged state change creates a stronger imprint.

## 2. What forms memory

Memory forms from:
- situation context (who, where, what was happening),
- state change,
- the lived feeling,
- the evaluation / conclusion made at that moment,
- relation meaning if another person was involved.

## 3. What memory stores

Memory may include:
- situation cues,
- phrases,
- key facts,
- bodily / emotional feel,
- the conclusion made then,
- relation tags,
- expectation tags.

Examples:
- “p2 let me down”
- “it is not safe with him”
- “I feel calmer near her”
- “it is hard to breathe in the shed when there are three of us”

Memory does not have to be objective.
It stores the lived version of the world.

## 4. Imprint format

```json
{
  "id": "imprint_001",
  "cues": ["river", "p2", "promise", "food"],
  "context_tags": ["scarcity", "reliability"],
  "relation_targets": ["p2"],
  "state_signature": ["hope", "tension", "hurt", "drop in trust"],
  "evaluation": "p2 betrayed me",
  "fragments": ["I trusted him", "he gave it to p1"],
  "strength": 82,
  "valence": "negative",
  "clarity": 0.74,
  "formed_at_tick": 41,
  "last_reactivated_tick": 88,
  "times_reactivated": 2
}
```

## 5. Formation rule

Memory strength depends not only on the peak reaction,
but on accumulated state change over time.

### 5.1 Formation inputs

Use normalized values in `0..1`:
- `peak_shift`
- `accumulated_shift`
- `social_meaning`
- `novelty`
- `repetition_bonus`

### 5.2 Default imprint strength formula

```text
formation_score =
  0.35 * peak_shift +
  0.35 * accumulated_shift +
  0.15 * social_meaning +
  0.10 * novelty +
  0.05 * repetition_bonus

imprint_strength = round(100 * clamp(formation_score, 0, 1))
```

Interpretation:
- strong sharp shift → large imprint
- prolonged accumulating change → also large imprint
- weak flat situation → little or no imprint

### 5.3 Formation threshold

Default:
- below `0.18` → usually no durable imprint
- `0.18..0.34` → weak trace
- `0.35..0.59` → stable memory
- `0.60+` → strong imprint

## 6. Weak and strong traces

- weak traces lose detail quickly and disappear,
- strong traces last longer and are more stable,
- strong traces may distort but do not vanish quickly.

## 7. Activation

When the current situation resembles a previous imprint,
the agent does not have to recall the past explicitly.

Instead, the imprint may act as:
- rapid evaluation,
- familiarity,
- anxiety,
- sympathy,
- felt pressure,
- felt safety.

This does not have to come with an explanation.

### 7.1 Activation inputs

Use normalized values in `0..1`:
- `cue_similarity`
- `strength_factor = imprint_strength / 100`
- `state_congruence`
- `relation_match`
- `recency_factor`
- `clarity_gate`

### 7.2 Default activation formula

```text
activation_score =
  0.30 * cue_similarity +
  0.20 * strength_factor +
  0.20 * state_congruence +
  0.15 * relation_match +
  0.10 * recency_factor +
  0.05 * clarity_gate
```

### 7.3 Activation bands

- `< 0.25` → no meaningful activation
- `0.25..0.49` → light bias only
- `0.50..0.74` → meaningful appraisal influence
- `0.75..0.89` → partial state reinstatement allowed
- `0.90+` → explicit memory flash possible

### 7.4 Tick limit

Do not foreground unlimited memories.
Default per tick:
- keep top `1..3` activated imprints,
- in acute survival mode keep top `1..2`.

## 8. Memory-triggered reinstatement

Memory activation can itself produce a fast state shift or partial state reinstatement.
That means the present state may change not only because of the objective event weight,
but because the current cues woke up an older lived state-pattern.

Examples:
- “I don’t know why, but I don’t like this”
- “I feel calmer with him”
- “this already smells bad”
- “something here feels familiar and wrong”

Rule:
- reinstatement is allowed only from activation `>= 0.75`
- the reinstated pattern must be partial unless the current cue is also objectively strong
- reinstatement modifies appraisal and field update size, but does not replace the current world event

## 9. Recall / memory drift

If an imprint is explicitly recalled,
it is not read back like an unchanged log.
It is reconstructed under the influence of current state.

- recall in a charged state may slightly intensify or distort the memory,
- recall in a calmer state distorts less,
- each emotionally charged reliving may strengthen both `strength` and `evaluation`.

Examples of drift:
- “he disappointed me” → “he betrayed me” → “he always does this”
- “it felt unpleasant” → “it is always tense around him”

The drift should be limited, not wild.

### 9.1 Drift rule

On explicit emotionally charged recall:
- `strength` may increase slightly,
- `clarity` may shift up or down,
- `evaluation` may intensify by one step,
- broad generalization is allowed only after repeated same-direction reactivations.

Do not let one recall rewrite the imprint into a completely different story.

## 10. Forgetting / fading

- weak imprints lose clarity, lose detail, and disappear,
- strong imprints last longer and may lose precision while keeping weight.

### 10.1 Default fading rule

Per meaningful time unit or quiet interval:
- weak traces lose `clarity` first,
- medium traces lose `clarity` slowly and `strength` slightly,
- strong traces mostly lose surface detail before weight.

Default heuristic:

```text
fade_pressure = quiet_time * forgetting_rate * (1 - strength_factor)
```

That means weak imprints fade faster than strong ones.

## 11. State-driven activation

### 11.1 State → memory activation

State determines which imprints activate:
- in a negative state (for example high stress, low mood), negative imprints activate more easily,
- in a more positive state, positive imprints activate more easily.

Not all memory is equally available at once.
Memory is a pool of traces, some of which rise depending on state.

### 11.2 Clarity effect

Low clarity does not mean “no memory”.
It usually means:
- rougher matching,
- stronger coarse familiarity / alarm / comfort effects,
- weaker nuanced differentiation.

### 11.3 Relation effect

If the current cue involves the same person, role, or dependency pattern,
relation-linked imprints activate more easily.

## 12. What memory may do in the packet

Memory may influence:
- noticed cue priority,
- appraisal weights,
- world feel,
- body feel,
- action pulls,
- relation updates,
- explicit flash-thoughts.

Memory must not be used as an excuse to skip the cue and appraisal steps.

## 13. Anti-patterns

Do not:
- treat memory as a full objective event log,
- activate unlimited imprints just because several are weakly similar,
- use explicit recall when only a bias effect is needed,
- let one memory overwrite the whole present situation,
- let drift become wild retconning,
- claim memory was involved without showing which imprint actually activated.
