# RELATION_MODEL.md — relation dynamics

This document defines how interpersonal relation state is modeled, updated, and used in simulation.
It follows the same architectural principles as `STATE_MODEL.md`:
- normalized generic meaning,
- character-local modifiers on top,
- behavior-grounded updates,
- memory interactions,
- non-linear effects near boundaries.

Use this together with:
- `docs/STATE_MODEL.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/CHARACTER_PROFILE_SCHEMA.md`

## 1. Core relational fields

Three primary dimensions.

### 1.1 trust (higher = more trust)

Meaning:
Expectation that another person will follow through, be reliable, be honest in a meaningful way, or not act against one's interests when it matters.

What builds trust:
- reliable follow-through on promises, especially under cost or pressure
- visible effort toward shared goals
- consistency between words and behavior over time
- admitting failure or uncertainty instead of deflecting
- showing competence when it was needed

What breaks trust:
- broken promises, especially without acknowledgment
- obvious deflection or excuse-making when the breach is visible
- repeated minor failures that accumulate
- timing failures without communication
- behavior perceived as self-serving at direct cost to self

### 1.2 resentment (higher = more resentment)

Meaning:
Accumulated grievance, friction, and readiness to interpret the other person's actions negatively or to feel that something unfair happened and has not been resolved.

What builds resentment:
- broken promise without acknowledgment
- perceived unfairness in burden-sharing
- being dismissed, ignored, or talked over
- being made to feel small, used, or taken for granted
- the other person's gain at one's expense without apparent concern
- repeated pattern of the same failure without repair attempt

What reduces resentment:
- genuine acknowledgment of the specific wrong
- visible repair attempt that matches the magnitude of the breach
- changed behavior demonstrated over time, not just promised
- recognition of the cost imposed on the other person

### 1.3 affinity (higher = more warmth)

Meaning:
Felt warmth, liking, pull toward closeness or softness toward another person.
Not the same as trust — you can trust someone you do not warm to, and you can warm to someone you do not fully trust.

What builds affinity:
- shared positive experience
- genuine warmth in tone when it feels authentic
- the other person making space for one's needs or feelings
- humor, lightness, mutual positive contact
- the other person being present or attentive when it mattered

What reduces affinity:
- repeated coldness or indifference when warmth was expected
- being treated as a tool or a burden
- the other person seeming to only value the relationship when it served them
- violation of felt intimacy or exposed vulnerability

## 2. Band semantics summary

For all three relation fields:
- `0..19`: critical — behavior is strongly shaped by this; withdrawal, defensiveness, or hostility likely
- `20..39`: strong negative — person is guarded, watchful, protective
- `40..59`: moderate — person is conditional, watchful for pattern
- `60..79`: positive — person is open, gives benefit of the doubt
- `80..100`: strong — person has solid relational foundation, can absorb minor breaches

Additional field-specific readings:
- high resentment has stronger inertia than high affinity
- low trust sharpens ambiguous reads more than low affinity alone
- affinity is the most volatile of the three

## 3. Relation-to-state interactions

Relations do not exist in isolation from body and emotion.

### 3.1 trust × state
- low trust + high stress → ambiguous behavior reads as deliberately negative more easily
- low trust + high pain or fatigue → fewer resources to give benefit of the doubt
- high trust + high stress → the person may still try conditional explanations before going fully negative

### 3.2 resentment × state
- high resentment + high stress → new grievance may produce non-linear jumps
- high resentment + low mood → repair attempts may fail to land
- high resentment + good mood buffer → there may be a narrow repair window before resentment locks in further

### 3.3 affinity × state
- low affinity + high stress → less warmth and patience available
- high affinity + repair attempt → softening is faster and more genuine-feeling
- high affinity + high stress → warmth can buffer but is not unlimited

## 4. How relation updates happen

### 4.1 Update trigger

A relation updates only if:
1. a behavioral event was available,
2. the character noticed it,
3. it was appraised as relationally meaningful.

### 4.2 Update sources

Relation shifts may come from:
- concrete behavior or its absence
- timing, especially unexplained delay or early return
- visible effort or its absence
- acknowledgment or dismissal
- repair attempt or failure to repair
- fairness perception in burden or resource distribution
- warmth or coldness in tone or contact
- exposure of vulnerability or its misuse

### 4.3 Default raw relation shift template

```text
raw_relation_shift(field, person) =
  appraisal_drive(field, person) *
  relation_susceptibility(field, person) *
  inertia_multiplier(field) *
  combo_multiplier *
  evidence_quality
```

Where:
- `appraisal_drive` comes from appraisal dimensions such as unfairness, warmth/safety, reliability, respect
- `relation_susceptibility` comes from the character profile
- `inertia_multiplier` is strongest for resentment, weaker for trust rebuilding, weakest for affinity
- `evidence_quality` discounts vague words and boosts costly behavioral evidence

### 4.4 Converting raw shift to points

Use the same mapping family as `STATE_MODEL.md`:

```text
if raw_relation_shift < 0.08:
  delta_points = 0
else:
  delta_points = round(25 * raw_relation_shift ^ 1.15)
```

Clamp by relation-specific practical limits.

## 5. Update heuristics by field

### 5.1 Trust
- builds slowly through consistent follow-through under pressure
- breaks faster than it builds
- requires behavioral evidence to rebuild, not just words
- once trust is broken, sustained effort is needed to rebuild

Default evidence rule:
- words alone can slightly slow further trust loss
- words alone should not produce meaningful trust gain

### 5.2 Resentment
- builds from perceived unfairness, broken promises, dismissals
- does not erase when the event is over
- reducing resentment is usually harder than building it

Default reduction rule:
- a major resentment band usually requires both acknowledgment and matching repair
- generic apology is insufficient

### 5.3 Affinity
- most volatile — can shift relatively quickly in either direction
- builds from positive contact, warmth, shared moments
- reduces from coldness, perceived misuse, indifference
- can act as a buffer but cannot erase deep trust damage by itself

## 6. Repair mechanics

Repair is not automatic.
It requires:
1. **Acknowledgment** — the specific breach must be named, not deflected
2. **Matching magnitude** — a major breach requires more than slight acknowledgment
3. **Behavioral change** — words alone do not rebuild trust; follow-through under pressure is needed
4. **Time and consistency** — repair after deep resentment requires sustained changed behavior

What does not repair:
- generic apology without specificity
- promise without demonstrated change
- “moving on” without acknowledgment
- reframing the breach as the wronged person's sensitivity
- explaining circumstances in a way that redirects blame without repair

## 7. Relation memory interactions

Relations and memory interact strongly:
- imprints from relational events can shift relations faster than gradual drift
- a new breach that matches a strong old imprint can produce a disproportionate jump in resentment
- a repair attempt that reactivates a positive memory imprint may land more easily than one that contradicts it
- under high stress or low mood, old relational imprints become easier to activate

## 8. Character-local modifiers

Generic relation meanings and bands are shared.
Character-local modifiers determine:
- repair threshold
- trust sensitivity
- warmth style
- tolerance for timing failure
- withdrawal vs confrontation tendency when relations deteriorate

Modifiers do not redefine the generic meaning of the number.
A trust of `40` means the same band for everyone; modifiers determine how the person got there and what it takes to move them.

## 9. What Run DM must not do

- do not change relation values without a behavioral trigger
- do not let trust increase from words alone without corresponding behavior
- do not treat a dramatic reconciliation scene as sufficient repair without matching behavioral substance
- do not treat a slightly positive moment as enough repair after major resentment
- do not erase resentment without acknowledgment having happened
- do not claim a relation update happened when only state shifted and relation was not specifically engaged
- do not let relation values be decorative — if trust is low, the person's reading of the other must reflect it
