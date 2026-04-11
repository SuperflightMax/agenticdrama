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
→ matching against current state, learned patterns, relations, and memory imprints  
→ fast significance appraisal  
→ confirmation or shift of state / relations  
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
- relation context,
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
a fast evaluation of the meaning and significance of the current signal through state, patterns, relations, and activated memory imprints.

This is not necessarily reflective analysis.
It can be an immediate:
- “this does not feel safe”
- “something is off”
- “I do not trust him here”
- “this is unfair”
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
- mechanism that recalculates how state, relations, and memory distort perception and significance.

DM should compute:
1. which cues are available in the world,
2. what the agent actually notices,
3. which imprints and patterns activate,
4. what appraisal arises,
5. how this shifts state and relations,
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

## Formal substrate documents

The detailed simulation substrate lives in:
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/CHARACTER_PROFILE_SCHEMA.md`
- `docs/PACKET_CONTRACT.md`
- `docs/CALIBRATION_SCENARIOS.md`

Interpretive prompts, bootstraps, and runtime procedures should derive from those documents instead of improvising replacements.
If a bootstrap, prompt, or convenience instruction conflicts with those contracts, the contracts win.

## Good run criterion

A good run is not the one with “many events” or a dramatic arc.
A good run is the one where it is possible to trace:
- which cues came from the world,
- which were actually noticed,
- which memories / relation hooks activated,
- which appraisal arose,
- how state and relation fields shifted,
- which action pulls became strong,
- why the agent chose that action.

## Anti-patterns

Forbidden:
- story steering instead of causality,
- replacing character agency with author convenience,
- presenting subjective thought as world fact,
- letting state / memory / relations exist only decoratively,
- claiming a model layer was used when it was silently skipped,
- using pretty output as proof that the model worked.

## One-line summary

**We do not model actions directly. We model how state, memory, relations, and learned patterns turn the same world into a subjective reality — and behavior emerges from that.**
