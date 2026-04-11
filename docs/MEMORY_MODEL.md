# MEMORY_MODEL.md — memory and state-driven activation

## Human-like memory

Player memory is not a full archive of events.
It forms automatically from state and state change.
A player cannot reliably decide to remember something just by will.
Strong or prolonged state change creates a stronger imprint.

## What forms memory

Memory forms from:
- situation context (who, where, what was happening),
- state change,
- the lived feeling,
- the evaluation / conclusion made at that moment.

## Main rule

Memory strength depends not only on the peak reaction,
but on accumulated state change over time.

That means:
- a sharp strong spike can create a strong memory,
- prolonged pressure or repeated experience can also create a strong memory.

## What memory stores

Memory may include:
- situation cues,
- phrases,
- key facts,
- bodily / emotional feel,
- the conclusion made then.

Examples:
- “p2 let me down”
- “it is not safe with him”
- “I feel calmer near her”
- “it is hard to breathe in the shed when there are three of us”

Memory does not have to be objective.
It stores the lived version of the world.

## Weak and strong traces

- weak traces lose detail quickly and disappear,
- strong traces last longer and are more stable,
- strong traces may distort but do not vanish quickly.

## Memory imprint format

```json
{
  "id": "imprint_001",
  "cues": ["river", "p2", "promise", "food"],
  "state_signature": ["hope", "tension", "hurt", "drop in trust"],
  "evaluation": "p2 betrayed me",
  "fragments": ["I trusted him", "he gave it to p1"],
  "strength": 82,
  "valence": "negative",
  "clarity": "vivid"
}
```

## Memory strength

Imprint strength depends on accumulated state change.

- strong sharp shift → large imprint
- prolonged accumulating change → also large imprint
- weak flat situation → almost no imprint

## Memory trigger

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

Important simulation rule:
memory activation can itself produce a fast state shift or partial state reinstatement.
That means the present state may change not only because of the objective event weight,
but because the current cues woke up an older lived state-pattern.

Examples:
- “I don’t know why, but I don’t like this”
- “I feel calmer with him”
- “this already smells bad”
- “something here feels familiar and wrong”

## Recall / memory drift

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

## Forgetting / fading

- weak imprints lose clarity, lose detail, and disappear,
- strong imprints last longer and may lose precision while keeping weight.

## State-driven perception

### State → memory activation

State determines which imprints activate:
- in a negative state (for example high stress, low mood), negative imprints activate more easily,
- in a more positive state, positive imprints activate more easily.

Not all memory is equally available at once.
Memory is a pool of traces, some of which rise depending on state.

### World feel

The same world feels different in different states:
- tense / heavy / hostile in a negative state,
- calm / open / manageable in a positive state.

### Attention bias

In a negative state:
- attention narrows toward threat and negativity,
- positive details are ignored or discounted.

In a more positive state:
- attention opens to possibilities and safety,
- negative details are smoothed over or ignored more easily.

### Reinterpretation

The same fact can mean different things:
- in the negative: neutral may feel fake / manipulative,
- in the positive: negative may feel tolerable / explainable.

The fact does not change. Its meaning does.

### State inertia

State tends to preserve itself:
- negative state seeks confirming evidence,
- positive state smooths and resists negativity.

### Resistance to change

State change requires enough event weight:
- in strong negativity, positive signals are discounted,
- in strong positivity, negative signals are softened.
