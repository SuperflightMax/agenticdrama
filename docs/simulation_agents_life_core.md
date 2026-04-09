# Simulation of agents' lives — core

## What we are building

This is not a scenario engine and not a generator of “interesting scenes”.
The goal is to model behavior that emerges from the agent's inner life: bodily state, attention, memory, learned patterns, appraisal, impulses, and decisions.

An agent should not “pick an action from a list because the plot wants it”.
The agent should live inside its own subjective version of what is happening.

## Project goal

The goal is to build a simulation in which behavior looks alive not because an author predesigned the scene,
but because each agent has:
- internal state,
- memory as a set of subjective imprints,
- learned patterns,
- distorted perception and significance,
- impulses and personal decisions.

The final aim is a system where the same world leads to different behavior in different agents,
and in the same agent when their state is different.

## Why this exists

The project is not for “plots” and not for pretty character chatter.

It exists to test and grow a model in which:
- state really changes perception,
- memory really changes appraisal,
- appraisal really changes action pulls,
- decisions really arise from internal dynamics rather than authorial convenience.

The point is not to generate a scene, but to build a believable mechanism for the emergence of behavior.

## Main principle

Behavior does not arise directly from a world event, but from a chain:

**world event
→ sensory cues
→ attention selection
→ matching against current state, learned patterns, and memory imprints
→ fast significance appraisal
→ confirmation or shift of state
→ change in salience, world feel, and action pulls
→ thoughts / impulses / interpretations
→ decision
→ action
→ consequences
→ new state changes and new imprints**

The key requirement is: **do not break this causal chain**.

## What state is

State is not just a bag of knobs and not something the world “changes directly”.

State is a product of:
- sensory input,
- already active state,
- learned patterns,
- memory,
- accumulated internal processes.

The world gives a signal.
The agent perceives, recognizes, matches, appraises — and only then does state shift.

## What memory is

Agent memory is not a full event archive.
It consists of **imprints** — traces of lived state change in context.

An imprint may include:
- situation cues,
- context,
- state signature,
- lived feel,
- evaluation / conclusion made then,
- fragments of phrases or facts,
- strength,
- valence,
- clarity.

Memory stores not objective truth, but the lived version of the world.

## How memory forms

Memory forms automatically.
An agent cannot reliably decide to remember something by force of will.

Memory strength depends on **accumulated state change**:
- a sharp strong spike can create a strong imprint,
- prolonged pressure or repeated experience can also create a strong imprint,
- weak flat episodes barely consolidate.

Strong memory comes not only from peaks, but from accumulated change over time.

## Example imprint format

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

## How memory affects behavior

An imprint does not have to surface as an explicit recollection.
More often it activates as:
- rapid evaluation,
- familiarity,
- anxiety,
- sympathy,
- distrust,
- pressure,
- safety.

That means memory can act without a conscious “I remembered”.
It can simply change appraisal of the present situation.

## Appraisal

Instead of vague “emotional coloring”, the project uses **appraisal**:
a fast evaluation of the meaning and significance of the current signal through state, patterns, and activated memory imprints.

This is not necessarily reflective analysis.
It can be an immediate:
- “this does not feel safe”
- “the light pulls me”
- “something is wrong”
- “I do not trust him”
- “it feels calmer near her”

Appraisal can be useful or harmful, accurate or wrong.

## State-driven perception

State influences:
- which cues enter attention at all,
- which imprints activate,
- what feels important,
- how meaning is interpreted,
- which action pulls arise.

Examples:
- in a negative state, negative imprints activate more easily, attention narrows to threat, and neutral signals are more easily read as suspicious;
- in a more positive state, positive imprints activate more easily, attention widens, and negative signals are more easily smoothed over or explained away.

State is not just “background”.
It changes access to memory, salience of signals, and the probability of interpretations.

## Why DM exists

DM is not just an event recorder and not an author of the scene.

DM is needed as:
- mediator of the objective world,
- consequence engine,
- subjective appraisal module,
- mechanism that recalculates how state and memory distort perception and significance.

DM should compute:
1. which cues are available in the world,
2. what the agent actually notices,
3. which imprints and patterns activate,
4. what appraisal arises,
5. how this shifts state,
6. which world feel, salience, and action pulls emerge from that.

## What DM may do

DM may and should provide the agent with:
- limited sensory input,
- attention bias,
- body feel,
- world feel,
- activated associations,
- brief subjective thought-flashes,
- action pulls,
- shifts in how events are felt.

DM is allowed to model subjectivity.

## What DM must not do

DM must not:
- present subjective interpretation as objective world fact,
- take the last step from impulse to decision for the character,
- replace the character's agency,
- steer behavior toward a nice story,
- collapse inner conflict without causality,
- write the “true meaning” of events instead of modeling the process.

DM may generate suspicion.
But must not declare the suspicion true.

DM may generate a pull toward action.
But must not decide for the character.

## What we are trying to get

We want a system where it becomes observable how:
- one agent starts avoiding,
- another clings,
- another controls,
- another freezes,
- another seeks warmth, light, or support,

and all of that happens not because roles were assigned, but because the model actually produced it.

The correct result is not an “interesting plot”, but convincing causal behavior.

## Why runs exist

Runs do not exist for the story itself.
A run is a **test stand for the model**.

A run checks:
- whether the causal chain holds,
- whether DM replaces characters,
- whether state really changes perception,
- whether memory really activates and affects appraisal,
- whether decisions arise naturally,
- whether story steering intrudes where the model should work,
- whether the pace feels natural instead of forced.

The purpose of a run is not “what came out”, but **how it came out and what it grew from**.

## What counts as a good run

A good run is not the one with “many events” or a “dramatic arc”.

A good run is one where you can see:
- which cues came from the world,
- what the agent noticed,
- which imprints / patterns activated,
- what appraisal arose,
- how state shifted,
- which impulses appeared,
- why the agent chose that action.

A good run is **diagnostics of the model in motion**.

## What counts as a bad run

A bad run is when:
- DM handwrites behavior,
- characters arrive at useful points too conveniently,
- thoughts are presented as world facts,
- decisions appear without the intermediate internal mechanics,
- memory affects nothing,
- state exists in numbers but does no work,
- the pacing feels pushed toward an arc or a tick limit.

Such a run may still be “interesting”, but it is not useful for model development.

## Why repeated runs matter

Repeated runs are needed to:
- expose systemic flaws,
- verify that fixes improve honesty,
- see which errors repeat,
- distinguish a lucky episode from a genuinely working mechanism,
- test the model over longer stretches.

One run shows an episode.
A series of runs shows **whether the model has an internal logic of its own**.

## Criterion of simulation quality

A good simulation is not the one where “it got interesting”.
A good simulation is one where you can trace:

**why this particular agent,
in this particular state,
with this memory and these patterns,
saw the situation this way,
and therefore did this.**

Even if the action was mistaken, harmful, or absurd, that is acceptable if it genuinely grew from the model.

## Main anti-patterns

Do not allow:
- story steering instead of causality,
- replacement of character agency by the author,
- subjective thoughts presented as world facts,
- behavior because “the scene wants it”,
- breaking the loop between body, state, perception, and action,
- a model where memory and state exist numerically but do not influence appraisal and decisions.

## Practical meaning of all this work

All work around the model, DM, logs, query/response structure, and longer runs exists for one reason:

**so that agent behavior emerges from internal causality rather than from an author's wish to obtain a beautiful scene.**

That is the core meaning of the project.

## Short one-line summary

**We do not model actions directly. We model how an agent's state, memory, and patterns transform the same world into a subjective reality — and behavior emerges from that reality.**
