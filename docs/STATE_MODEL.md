# STATE_MODEL.md — canonical state semantics and update logic

This document turns the project's qualitative state logic into an explicit simulation contract.
Its job is to make Run DM compute state consistently enough that behavior emerges from internal causality rather than prompt improvisation.

Use together with:
- `docs/simulation_agents_life_core.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/CHARACTER_PROFILE_SCHEMA.md`

## 0. Boundary between math and DM interpretation

The purpose of state math is to provide a reliable causal substrate, not to fully replace DM interpretation.

So the intended layering is:
- math / mechanics define stable state meaning, bands, modifiers, update logic, and constraints
- Run DM interprets the resulting configuration into a lived subjective moment and concrete packet

If an effect can already be derived from the shared mechanics plus DM interpretation, do not add a new special parameter too quickly.
If DM keeps having to improvise the same missing base logic, formalize that base logic in docs.

## 1. Core principle

State does not change directly because the world changed.
State changes only after:

**world event → available cues → noticed cues → appraisal through current state / memory / learned patterns / relations → state shift**

Run DM must preserve this order.

## 2. Numeric convention

Unless a campaign explicitly overrides it, active state fields use a `0..100` scale.

### 2.1 Normalization principle

The purpose of state math is not only to track local change,
but to create a comparable reference frame.
If two characters both have `stress = 70`, that should mean the same generic severity band before character-local modifiers are applied.

So the model splits into two layers:
- **normalized generic state meaning**
- **character-local response profile**

### 2.2 Polarity convention

Some fields are **higher is worse**:
- hunger
- fatigue
- stress
- pain

Some are **higher is better**:
- mood
- health
- clarity
- mobility

For formulas, convert to normalized directional pressure:

```text
n = value / 100

if higher_is_worse:
  pressure = n
if higher_is_better:
  pressure = 1 - n
```

This lets cross-effects reason about severity in one shared direction.

### 2.3 Bands

Default band interpretation:
- band 0: `0..19`
- band 1: `20..39`
- band 2: `40..59`
- band 3: `60..79`
- band 4: `80..100`

These bands are not linear in lived effect.
Crossing a band boundary matters more than drifting inside a band.

## 3. State field meanings

### 3.1 hunger (higher = worse)
Meaning:
- bodily pressure toward food
- reduced tolerance for delay, sharing loss, and low-yield effort
- stronger salience of food, warmth, and near-term relief

### 3.2 fatigue (higher = worse)
Meaning:
- depleted energy and reduced coping bandwidth
- reduced ability to sustain effort, complexity, and repair behavior

### 3.3 stress (higher = worse)
Meaning:
- threat load, vigilance, internal pressure, urgency burden

### 3.4 mood (higher = better)
Meaning:
- current positive/negative background coloring of the lived world
- a fast-moving aggregate field, not the only deep cause

Modeling rule:
- `mood` is more labile than `stress`, `fatigue`, `health`, or `hunger`
- many events should move mood first
- mood may buffer or amplify the felt impact of the same objective cue without replacing slower pressures underneath

### 3.5 health (higher = better)
Meaning:
- general bodily robustness and recovery capacity
- baseline ability to absorb strain without cascading collapse

### 3.6 pain (higher = worse)
Meaning:
- direct bodily cost and irritation pressure
- attentional pull into the body

### 3.7 clarity (higher = better)
Meaning:
- cognitive organization, interpretive coherence, ability to hold multiple factors at once

### 3.8 mobility (higher = better)
Meaning:
- practical ease of repositioning, carrying, acting, going out, or changing zone

### 3.9 acute survival state (mode, not ordinary scalar)
This is not just another everyday slider.
It is a special regime that may activate when the organism appraises the situation as a threat to continued life, core safety, or loss of a life-support foundation.

When active, typical effects include:
- severe narrowing of problem space
- collapse of multi-topic thinking into one vital axis
- simplified time horizon
- stronger freeze / cling / flee / attack / appease emergency pulls
- degraded nuance and social complexity handling

## 4. Default band semantics by field

### 4.1 For higher-is-worse fields
- `0..19`: minimal pressure, usually background only
- `20..39`: noticeable pressure, influences salience but does not dominate
- `40..59`: active pressure, regularly shapes attention and appraisal
- `60..79`: strong pressure, clearly narrows options and tolerance
- `80..100`: critical pressure, strongly distorts perception and pushes immediate coping behavior

### 4.2 For higher-is-better fields
- `0..19`: severe impairment / collapse band
- `20..39`: strong impairment
- `40..59`: compromised but functional
- `60..79`: stable / generally workable
- `80..100`: strongly resourced / high-function band

## 5. Character-local modifiers and baseline profiles

Current values alone are not enough.
Different characters must not only have different current numbers, but also different **response curves**.
Otherwise two people with the same numbers will still be simulated too similarly.

For each active character, Run DM should distinguish between:
- current state values,
- character-local baseline tendencies,
- character-local sensitivities / resistances,
- character-local recovery style.

These live in `docs/CHARACTER_PROFILE_SCHEMA.md` and campaign cast data.

## 6. Universal field pool and dynamic salience

The model should not split into totally different isolated state systems for each environment.
A character remains one organism with one psyche whether the current pressure is social, practical, dangerous, intimate, or physical.

Campaigns may declare which fields are actively tracked or emphasized.
That means:
- which fields Run DM must compute explicitly,
- which fields are expected to matter often,
- which fields are likely to appear in subjective packets.

Not every field must dominate every tick.
Run DM should decide which fields are currently foregrounded by:
- current environment,
- current cues,
- current task demands,
- current social meaning,
- current memory activation,
- current state bands.

## 7. Cross-effects

These are default tendencies Run DM should apply unless a campaign overrides them.

### 7.1 stress × clarity
- high stress tends to drag clarity down
- low clarity makes stress harder to regulate because interpretation becomes cruder
- combination effect: more tunnel vision, worse nuance, faster leap from cue to suspicion

### 7.2 fatigue × clarity
- high fatigue lowers planning depth and interpretive precision
- low clarity makes fatigue more behaviorally visible because the actor stops compensating well

### 7.3 pain × mobility
- pain raises the felt cost of movement and practical action
- low mobility can make pain more salient because movement stops being a viable coping option

### 7.4 health × everything else
- low health magnifies the impact of pain, hunger, fatigue, and cold
- high health can buffer deterioration but should not erase other pressures

### 7.5 mood × memory activation
- lower mood makes negative imprints easier to activate
- higher mood makes positive / safe / smoothing imprints easier to activate
- mood often works as a fast amplifier or dampener of already-existing pressure

### 7.6 stress × relations
- high stress makes low-trust or high-resentment reads sharpen faster
- under lower stress, the same relation state may remain latent instead of dominant

## 8. Perception effects

State changes:
- which cues enter attention at all
- which cues become salient first
- which memories activate
- how social ambiguity is read
- how much complexity the character can hold before acting

Default tendencies:
- high stress → narrower attention, more threat-focused reading
- high fatigue → fewer cues retained, less complex planning
- low mood → negative interpretation bias
- high hunger → resource and fairness cues gain weight
- high pain → bodily and effort-related cues gain weight
- low clarity → worse distinction between cue and interpretation

Capture rule:
- some very high-band states do not merely bias perception, they begin to dominate it
- in such cases other concerns are not erased from existence, but they lose effective priority

## 9. Decision effects

State should not directly choose action.
Instead it shapes:
- action pulls available
- strength of each pull
- willingness to tolerate uncertainty
- willingness to repair, wait, check, or cooperate

Examples:
- high stress + low clarity → fast protective / suspicious / simplifying responses
- high fatigue + high hunger → short-path relief choices
- low mood + low trust → colder appraisal of ambiguous behavior
- high pain + low mobility → avoidance, staying put, asking others, conserving effort
- high clarity + moderate stress → checking / verifying instead of instantly reacting

## 10. Transfer and update logic summary

Detailed math lives in `docs/UPDATE_RULES.md`, but these are the default state rules.

### 10.1 Update sources

State shifts may come from:
- bodily/environmental pressure (cold, hunger, pain, exhaustion, relief)
- social meaning (delay, promise, dismissal, visible effort, repair, silence)
- memory activation (fear, shame, safety, familiarity, suspicion)
- accumulated strain over several ticks
- sharp spikes or shocks
- acute regime switch

### 10.2 Default raw shift template

For a field affected by the current appraisal:

```text
raw_shift(field) =
  appraisal_drive(field) *
  field_susceptibility(field) *
  band_multiplier(field) *
  combo_multiplier *
  inertia_multiplier *
  regime_multiplier
```

Where:
- `appraisal_drive(field)` comes from appraisal dimensions relevant to that field
- `field_susceptibility(field)` comes from the character profile
- `band_multiplier(field)` becomes steeper near critical bands
- `combo_multiplier` amplifies aligned pressures
- `inertia_multiplier` resists recovery or accelerates worsening depending on current state
- `regime_multiplier` is usually `1.0`, but may increase in acute survival mode

### 10.3 Converting raw shift to points

Default mapping:

```text
if raw_shift < 0.08:
  delta_points = 0
else:
  delta_points = round(25 * raw_shift ^ 1.15)
```

Then clamp by field:
- slight shift: `1..5`
- moderate shift: `6..12`
- major shift: `13..25`

The tier is derived from magnitude, not chosen by story feel.

### 10.4 Inertia

Existing state has inertia.
- already-high stress rises more easily from threat cues and falls more slowly
- already-low mood discounts positive signals more easily
- already-high fatigue keeps reducing recovery bandwidth

Default rule:
- same-direction worsening in bad bands gets `1.05..1.35`
- recovery in bad bands gets `0.65..0.95`

### 10.5 Recovery distinction

Rate of change and behavioral importance are not the same.
A field may change slowly across time yet strongly shape appraisal right now if its current value is already severe.

## 11. Acute survival mode rules

Use a dedicated trigger score rather than pure intuition.

### 11.1 Acute score

Use normalized values in `0..1`:
- `direct_threat`
- `vital_support_loss`
- `control_collapse`
- `dependency_collapse`
- `survival_imprint_activation`
- `safety_buffer`

```text
acute_score =
  0.30 * direct_threat +
  0.20 * vital_support_loss +
  0.15 * control_collapse +
  0.15 * dependency_collapse +
  0.15 * survival_imprint_activation -
  0.10 * safety_buffer
```

### 11.2 Activation / deactivation

- activate if `acute_score >= 0.80`
- or if `acute_score >= 0.65` for two meaningful ticks in a row
- deactivate only after `acute_score < 0.45` for multiple ticks and the threat meaning has genuinely loosened

### 11.3 Effect of mode

Acute survival mode may:
- reduce attention capacity,
- narrow planning,
- increase emergency action pulls,
- reduce social nuance,
- increase weighting of safety / threat cues.

It must not directly choose the final action.

## 12. What Run DM must not do

Run DM must not:
- use state numbers as decorative color only
- change state directly from objective event with no appraisal step
- silently turn prose intuition into fake formal mechanics
- claim a model layer was used when it was skipped
- use acute survival mode as a dramatic shortcut without meeting trigger conditions
