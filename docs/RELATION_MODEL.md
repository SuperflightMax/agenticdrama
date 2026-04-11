# RELATION_MODEL.md — relation dynamics

## Purpose

This document defines how interpersonal relation state is modeled, updated, and used in simulation.
It follows the same architectural principles as STATE_MODEL.md:
- normalized generic meaning,
- character-local modifiers on top,
- behavior-grounded updates,
- memory interactions,
- non-linear effects near boundaries.

Use this together with:
- `docs/STATE_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `rules.md`
- campaign-specific `SIMULATION_RULES.md`

---

## 1. Core relational fields

Three primary dimensions.

### 1.1 trust (higher = more trust)

**Meaning:**
Expectation that another person will follow through, be reliable, be honest in a meaningful way, or not act against one's interests when it matters.

**What builds trust:**
- reliable follow-through on promises, especially under cost or pressure
- visible effort toward shared goals
- consistency between words and behavior over time
- admitting failure or uncertainty instead of deflecting
- showing competence when it was needed

**What breaks trust:**
- broken promises, especially without acknowledgment
- obvious deflection or excuse-making when the breach is visible
- repeated minor failures that accumulate
- timing failures without communication
- when the other person's behavior is perceived as self-serving at direct cost to self

**Behavioral read at each band:**
- 80-100: solid relational foundation, small breaches can be absorbed, repair is relatively easy
- 60-79: workable trust, person gives benefit of the doubt conditionally, monitors for pattern
- 40-59: uncertain, conditional, person watchful, will verify
- 20-39: significant friction, person defensive, interpreting ambiguously against you
- 0-19: critical — person assumes negative intent or unreliability, may avoid engagement

### 1.2 resentment (higher = more resentment)

**Meaning:**
Accumulated grievance, friction, and readiness to interpret the other person's actions negatively or to feel that something unfair happened and has not been resolved.

**What builds resentment:**
- broken promise without acknowledgment
- perceived unfairness in burden-sharing
- being dismissed, ignored, or talked over
- being made to feel small, used, or taken for granted
- the other person's gain at one's expense without apparent concern
- repeated pattern of the same failure without repair attempt

**What reduces resentment:**
- genuine acknowledgment of the specific wrong
- visible repair attempt that matches the magnitude of the breach
- changed behavior demonstrated over time, not just promised
- recognition of the cost imposed on the other person

**Important:**
Resentment does not simply erase when the triggering event is over.
It has inertia.
The person may appear calm on the surface while still carrying the resentment underneath.

**Behavioral read at each band:**
- 80-100: deep grievance, person may be preparing withdrawal or retaliation, very hard to reach
- 60-79: strong friction, person actively guarded, may respond coldly or defensively
- 40-59: moderate grievance, person reserved but not hostile, watching for pattern
- 20-39: mild friction, recoverable with consistent repair
- 0-19: minimal grievance, person open to neutral or positive engagement

### 1.3 affinity (higher = more warmth)

**Meaning:**
Felt warmth, liking, pull toward closeness or softness toward another person. Not the same as trust — you can trust someone you don't warm to, and you can warm to someone you don't fully trust.

**What builds affinity:**
- shared positive experience
- genuine warmth in tone when it feels authentic
- the other person making space for one's needs or feelings
- humor, lightness, mutual positive contact
- the other person being present or attentive when it mattered

**What reduces affinity:**
- repeated coldness or indifference when warmth was expected
- being treated as a tool or a burden
- the other person seeming to only value the relationship when it served them
- violation of felt intimacy or exposed vulnerability

**Behavioral read at each band:**
- 80-100: strong warmth and pull toward closeness, person actively seeks contact, generous interpretation
- 60-79: positive warmth, person engages willingly, open to softening
- 40-59: neutral or mixed, person neither seeks nor avoids closeness
- 20-39: cooled, person withdrawn or neutral, harder to warm
- 0-19: cold or actively反感, person avoids or resists engagement

---

## 2. Relation-to-state interactions

Relations do not exist in isolation from body and emotion.

### 2.1 trust x state
- Low trust + high stress → person reads ambiguous behavior as deliberately negative
- Low trust + high pain or fatigue → person has fewer resources to give benefit of the doubt
- High trust + high stress → person may still give conditional explanations before going negative
- High trust + moderate state → breaches can be absorbed and repaired more easily

### 2.2 resentment x state
- High resentment + high stress → person is already at boundary; new grievance may produce non-linear jump
- High resentment + low mood → repair attempts may fail to land
- High resentment + good mood buffer → repair attempt may have a window before resentment locks in further

### 2.3 affinity x state
- Low affinity + high stress → person less likely to extend warmth or patience
- Low affinity + good state → person still may engage but more conditionally
- High affinity + repair attempt → softening is faster and more genuine-feeling
- High affinity + high stress → warmth can act as buffer but is not unlimited

---

## 3. How relation updates happen

### 3.1 Update trigger

Same principle as state model:
A relation updates only if:
1. a behavioral event was available,
2. the character noticed it,
3. it was appraised as relationally meaningful.

### 3.2 Update sources

Relation shifts may come from:
- concrete behavior or its absence
- timing, especially unexplained delay or early return
- visible effort or its absence
- acknowledgment or dismissal
- repair attempt or failure to repair
- fairness perception in burden or resource distribution
- warmth or coldness in tone or contact
- exposure of vulnerability or its misuse

### 3.3 Update magnitudes

Same three-tier default as STATE_MODEL:
- slight shift: 1..5
- moderate shift: 6..12
- major shift: 13..25

Heuristics:
- first minor breach of a promise → usually moderate on resentment, slight on trust
- repeated same breach without repair → major on resentment, moderate-to-major on trust
- genuine acknowledgment + changed behavior → moderate on trust, moderate on resentment reduction
- promise made and kept under pressure → moderate on trust
- cold dismissal when warmth was expected → moderate on affinity reduction
- warm positive contact during shared task → moderate on affinity increase

### 3.4 Inertia and non-linearity

- Resentment has strong inertia once it passes a threshold
- Trust rebuilding is usually slower than trust breaking
- Multiple smaller breaches can accumulate into a major shift even if each single breach was small
- A repair attempt that matches the breach in specificity and magnitude produces more change than a generic apology
- Affinity is the most volatile — it can shift relatively quickly in either direction from a meaningful moment

---

## 4. Repair mechanics

Repair is not automatic.
It requires:

1. **Acknowledgment** — the specific breach must be named, not deflected
2. **Matching magnitude** — a major breach requires more than a slight acknowledgment
3. **Behavioral change** — words alone do not rebuild trust; follow-through under pressure is needed
4. **Time and consistency** — repair after deep resentment requires sustained changed behavior, not one event

What does NOT repair:
- generic apology without specificity
- promise without demonstrated change
- "moving on" without acknowledgment
- reframing the breach as the wronged person's sensitivity
- explaining the circumstances in a way that redirects blame

---

## 5. Relation memory interactions

Relations and memory interact strongly:
- Imprints from relational events (broken promise, repair, humiliation, warmth) can shift relations faster than gradual drift
- A new breach that matches a strong old imprint can produce a disproportionate jump in resentment
- A repair attempt that reactivates a positive memory imprint may land more easily than one that contradicts it
- Under high stress or low mood, old relational imprints become easier to activate

---

## 6. Character-local modifiers

Same principle as STATE_MODEL:
- Generic relation meanings and bands are shared.
- Character-local modifiers determine:
  - repair threshold (how much repair effort is needed to shift this person's resentment)
  - trust sensitivity (what kinds of breaches hit hardest for this person)
  - warmth style (how this person expresses and receives warmth)
  - tolerance for timing failure (some people are more sensitive to delays than others)
  - withdrawal vs confrontation tendency when relations deteriorate

Modifiers do NOT redefine the generic meaning of the number.
A trust of 40 means the same band for everyone; the modifiers determine how this person got to 40 and what it takes to move it.

---

## 7. Band semantics summary

For all three relation fields:
- 0-19: critical — behavior is strongly shaped by this; withdrawal, defensiveness, or hostility likely
- 20-39: strong negative — person is guarded, watchful, protective
- 40-59: moderate — person is conditional, watchful for pattern
- 60-79: positive — person is open, gives benefit of the doubt
- 80-100: strong — person has solid relational foundation, can absorb minor breaches

---

## 8. What Run DM must not do

- Do not change relation values without a behavioral trigger
- Do not let trust increase from words alone without corresponding behavior
- Do not treat a "dramatic reconciliation scene" as sufficient repair without matching behavioral substance
- Do not treat a slightly positive moment as enough repair after major resentment
- Do not erase resentment without acknowledgment having happened
- Do not claim a relation update happened when only state shifted and relation was not specifically engaged
- Do not let relation values be decorative — if trust is low, the person's reading of the other must reflect it
