# STATE_MODEL.md — canonical state semantics and update logic

This document turns the project's qualitative state logic into an explicit simulation contract.
It is intentionally not a game-y stat block for optimizing scenes.
Its job is to make Run DM compute state consistently enough that behavior emerges from internal causality rather than prompt improvisation.

Use this together with:
- `docs/simulation_agents_life_core.md`
- `docs/MEMORY_MODEL.md`
- `rules.md`
- campaign-specific `SIMULATION_RULES.md`

## 1. Core principle

State does not change directly because the world changed.
State changes only after:

**world event -> available cues -> noticed cues -> appraisal through current state / memory / learned patterns / relations -> state shift**

Run DM must preserve this order.

## 2. Numeric convention

Unless a campaign explicitly overrides it, active state fields use a `0..100` scale.

Interpretation:
- `0..19` = extreme / critical band
- `20..39` = strong negative band
- `40..59` = moderate / mixed band
- `60..79` = stable / good band
- `80..100` = strong / high-function band

Important:
- not every parameter uses the same polarity
- some are **higher is worse** (`hunger`, `fatigue`, `stress`, `pain`)
- some are **higher is better** (`mood`, `health`, `clarity`, `mobility`)

## 3. State field meanings

### 3.1 hunger (higher = worse)
Meaning:
- bodily pressure toward food
- reduced tolerance for delay, sharing loss, and low-yield effort
- stronger salience of food, warmth, and near-term relief

Typical effects:
- attention shifts toward food, rationing, unfair distribution, promises around food/water
- appraisal becomes less tolerant of waste and empty delay
- action pulls tilt toward immediate resource securing
- social patience falls as hunger rises

### 3.2 fatigue (higher = worse)
Meaning:
- depleted energy and reduced coping bandwidth
- reduced ability to sustain effort, complexity, and repair behavior

Typical effects:
- narrower attention
- weaker planning depth
- lower willingness for multi-step or socially delicate action
- more reliance on habits, short paths, and immediate comfort

### 3.3 stress (higher = worse)
Meaning:
- threat load, vigilance, internal pressure, urgency burden

Typical effects:
- attention narrows toward risk, ambiguity, delay, and possible slippage
- threat reading intensifies
- neutral signals are more easily read as loaded
- fast protective action pulls become more likely

### 3.4 mood (higher = better)
Meaning:
- baseline positive/negative world coloring
- not a single emotion, but the current background tilt of interpretation

Typical effects:
- low mood biases appraisal negative
- high mood makes repair, benefit-of-doubt, and tolerance easier
- mood influences which memory traces activate more easily

### 3.5 health (higher = better)
Meaning:
- general bodily robustness and recovery capacity
- baseline ability to absorb strain without cascading collapse

Typical effects:
- low health amplifies cost of cold, effort, pain, hunger, and fatigue
- low health makes recovery weaker and setbacks more sticky
- high health buffers deterioration somewhat but does not cancel pressure

### 3.6 pain (higher = worse)
Meaning:
- direct bodily cost and irritation pressure
- attentional pull into the body

Typical effects:
- movement and effort feel more expensive
- irritability and shortness increase
- clarity may drop under sustained pain
- protective / avoidant action pulls rise

### 3.7 clarity (higher = better)
Meaning:
- cognitive organization, interpretive coherence, ability to hold multiple factors at once

Typical effects:
- low clarity reduces planning depth and nuance
- low clarity increases misreading and oversimplified appraisal
- high clarity supports better differentiation between cue, interpretation, and suspicion

### 3.8 mobility (higher = better)
Meaning:
- practical ease of repositioning, carrying, acting, going out, or changing zone

Typical effects:
- low mobility reduces reachable affordances
- low mobility raises the cost of action even when motivation exists
- high mobility makes task-taking, repair-through-action, and response options broader

## 4. Band semantics by field

These are default tendencies, not hard equations.

### For higher-is-worse fields: hunger, fatigue, stress, pain
- `0..19`: minimal pressure, usually background only
- `20..39`: noticeable pressure, influences salience but does not dominate
- `40..59`: active pressure, regularly shapes attention and appraisal
- `60..79`: strong pressure, clearly narrows options and tolerance
- `80..100`: critical pressure, strongly distorts perception and pushes immediate coping behavior

### For higher-is-better fields: mood, health, clarity, mobility
- `0..19`: severe impairment / collapse band
- `20..39`: strong impairment
- `40..59`: compromised but functional
- `60..79`: stable / generally workable
- `80..100`: strongly resourced / high-function band

## 5. Character-local modifiers and baseline profiles

The generic state model is not enough by itself.
Different characters must not only have different current values, but also different **response curves**.
Otherwise two people with different personalities but the same numbers will still be simulated too similarly.

For each active character, Run DM should distinguish between:
- current state values,
- character-local baseline tendencies,
- character-local sensitivities / resistances,
- character-local recovery style.

### 5.1 Current state values
These are the live numbers in the current run, for example:
- hunger 32
- stress 45
- clarity 72

They answer: **where is the character right now?**

### 5.2 Baseline tendencies
These are trait-like default tendencies for this character.
They answer: **what does this character tend to be like before the current moment adds pressure?**

Examples:
- naturally high vigilance around reliability cues
- low baseline tolerance for bodily discomfort
- naturally good practical stamina
- usually decent clarity under neutral conditions
- quick-to-soften after visible repair

### 5.3 Sensitivities and resistances
These are local modifiers on top of the generic state model.
They answer: **what hits this character harder or weaker than average?**

Examples:
- delay / vagueness may raise stress faster for one character
- bodily pain may cut clarity harder for one character than another
- hunger may produce unfairness-reading quickly in one character, but mostly withdrawal in another
- one character may resist panic but collapse into fatigue faster

### 5.4 Recovery style
These are character-specific rules for what actually repairs state.
They answer: **what reduces pressure for this character, and what fails to help?**

Examples:
- one character calms through explicit explanation
- one calms only through visible follow-through
- one recovers mood from warmth and soft social contact
- one needs solitude or task completion rather than talk

### 5.5 Required modeling rule
Run DM must not treat all characters as identical processors with different current numbers only.
Current values are the live state.
Character-local modifiers determine how strongly cues translate into appraisal, state change, and action pulls for that specific person.

### 5.6 Where these live
Character-local modifiers should come from:
1. the character soul / continuity / reviewed spec,
2. campaign-specific cast materials,
3. explicit run packet instructions.

If a character-local modifier matters for an outcome and is not defined anywhere reliable, Lab DM should add it to the character materials instead of leaving Run DM to freestyle it indefinitely.

## 6. Cross-effects

These are default cross-field tendencies Run DM should apply unless a campaign overrides them.

### 5.1 stress x clarity
- high stress tends to drag clarity down
- low clarity makes stress harder to regulate because interpretation becomes cruder
- combination effect: more tunnel vision, worse nuance, faster leap from cue to suspicion

### 5.2 fatigue x clarity
- high fatigue lowers planning depth and interpretive precision
- low clarity makes fatigue more behaviorally visible because the actor stops compensating well

### 5.3 pain x mobility
- pain raises the felt cost of movement and practical action
- low mobility can make pain more salient because movement stops being a viable coping option

### 5.4 health x everything else
- low health magnifies the impact of pain, hunger, fatigue, and cold
- high health can buffer deterioration but should not erase other pressures

### 5.5 mood x memory activation
- lower mood makes negative imprints easier to activate
- higher mood makes positive / safe / smoothing imprints easier to activate

### 5.6 stress x relations
- high stress makes low-trust or high-resentment reads sharpen faster
- under lower stress, the same relation state may remain latent instead of dominant

## 7. Perception effects

Run DM should not treat state as a decorative afterthought.
State changes:
- which cues enter attention at all
- which cues become salient first
- which memories activate
- how social ambiguity is read
- how much complexity the character can hold before acting

Default tendencies:
- high stress -> narrower attention, more threat-focused reading
- high fatigue -> fewer cues retained, less complex planning
- low mood -> negative interpretation bias
- high hunger -> resource and fairness cues gain weight
- high pain -> bodily and effort-related cues gain weight
- low clarity -> worse distinction between cue and interpretation

## 8. Decision effects

State should not directly choose action.
Instead it shapes:
- action pulls available
- strength of each pull
- willingness to tolerate uncertainty
- willingness to repair, wait, check, or cooperate

Examples:
- high stress + low clarity -> fast protective / suspicious / simplifying responses
- high fatigue + high hunger -> short-path relief choices
- low mood + low trust -> colder appraisal of ambiguous behavior
- high pain + low mobility -> avoidance, staying put, asking others, conserving effort
- high clarity + moderate stress -> checking / verifying instead of instantly reacting

## 9. How state updates happen

### 8.1 Update trigger
A state update should happen only if something was:
1. available in the world,
2. actually noticed,
3. appraised as meaningful by this character.

No direct world-to-state jump.

### 8.2 Update sources
State shifts may come from:
- bodily/environmental pressure (cold, hunger, pain, exhaustion, relief)
- social meaning (delay, promise, dismissal, visible effort, repair, silence)
- memory activation (fear, shame, safety, familiarity, suspicion)
- accumulated strain over several ticks
- sharp spikes or shocks

### 8.3 Update size
Use three default magnitudes unless campaign rules require more detail:
- slight shift: 1..5
- moderate shift: 6..12
- major shift: 13..25

Heuristics:
- weak but noticeable cue -> slight
- clear meaningful cue hitting a live sensitivity -> moderate
- shock, repeated accumulated pressure, or heavily memory-loaded cue -> major

### 8.4 Inertia
Existing state has inertia.
- already-high stress rises more easily from threat cues and falls more slowly
- already-low mood discounts positive signals more easily
- already-high fatigue keeps reducing recovery bandwidth

Positive signals do not automatically erase negative build-up in one step.

## 10. When a state shift is significant enough to matter in logs

A shift matters enough for runtime reasoning when at least one is true:
- it changes the band of a parameter
- it changes attention bias or appraisal direction
- it changes the available action pulls
- it creates or resolves a meaningful social interpretation
- it contributes to memory formation

## 11. Memory formation rule

Memory does not form from every event.
A new imprint becomes likely when there is meaningful accumulated state change, especially if the moment includes:
- sharp spike
- repeated same-pattern strain
- strong social meaning
- strong relief after strain
- strong betrayal / repair / exposure / safety moment

Imprints should encode:
- cues
- state signature
- evaluation made at the time
- fragments if relevant
- strength / valence / clarity

## 12. Relation interaction rule

State and relations should be computed together, not separately.
For example:
- a delay from a high-trust person under low stress may read as explainable
- the same delay from a low-trust person under high stress may read as loaded or unsafe

Relation values do not directly cause action.
They bias appraisal and repair thresholds.

## 13. What Run DM must not do

Run DM must not:
- use state numbers as decorative color only
- change state directly from objective event with no appraisal step
- let players decide from omniscient neutral context
- silently turn prose intuition into fake formal state mechanics
- claim a model layer was used when it was skipped

## 14. Current limitation

This document defines default semantics and bands, but still leaves room for campaign-specific overrides.
If a campaign needs harder equations or custom thresholds, place them in that campaign's `SIMULATION_RULES.md` and treat that file as a local override.
