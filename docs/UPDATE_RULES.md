# UPDATE_RULES.md — how state and relations update

## Purpose

This document defines the update mechanics for both state fields and relation fields.
It complements STATE_MODEL.md and RELATION_MODEL.md with the mechanics of how changes actually happen.

Use together with:
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `rules.md`

---

## 1. The core update principle

No field updates from a raw world event.
A field updates only after:

**world event → available cues → noticed cues → appraisal → field shift**

Run DM must preserve this order.

---

## 2. When does appraisal become a field update

Not every appraisal leads to a field update.
A field shift happens when:

1. The cue was noticed and appraised as meaningful by the character
2. The appraisal carried sufficient weight for this character at this moment
3. The resulting shift is large enough to cross a meaningful threshold

A field may update when:
- an event has sufficient weight for this character
- an accumulated pattern has reached a threshold
- a buffer or compensator collapsed
- a memory imprint was activated that shifted the felt state
- an acute regime switched on or off

---

## 3. Update sources

### State fields update from:
- immediate bodily/environmental signal (pain spike, cold shock, sudden relief, exhaustion)
- accumulated strain over several ticks
- sharp spike or shock
- memory-triggered state reinstatement
- buffer/compensator collapse
- acute regime switch

### Relation fields update from:
- concrete behavior or its absence
- timing (delay, early return, unexplained absence)
- visible effort or its absence
- acknowledgment or dismissal
- repair attempt or failure to repair
- fairness in burden or resource sharing
- warmth or coldness in tone or contact
- exposure or misuse of vulnerability

---

## 4. Update magnitudes

Three default tiers:

**Slight:** 1-5
- minor cue, weak signal, or first hint of pattern
- usually does not cross band boundaries

**Moderate:** 6-12
- clear meaningful cue hitting a live sensitivity
- pattern recognition
- first acknowledgment or repair gesture

**Major:** 13-25
- shock, repeated accumulated pressure, heavily memory-loaded cue
- major breach or major repair
- buffer collapse
- regime switch

**Important rules:**
- Deltas do not add linearly in the same way at every range
- Near band boundaries, a moderate delta can cross the band
- Multiple aligned pressures in the same direction produce disproportionately larger effect
- Combination effects (e.g., high stress + low trust + low clarity) are stronger than sum-of-parts

---

## 5. Temporal rules

### Speed of change varies by field type

**Fast-reactive fields** may shift from single events:
- mood
- pain
- acute arousal
- some buffers/modulators
- affinity (most volatile relation field)

**Slow-accumulating fields** change gradually and have inertia:
- stress
- fatigue
- hunger
- health
- trust
- resentment (has strong inertia once established)

### Practical implications:
- A single event may sharply move mood but barely touch stress
- The same event may later influence slower fields through changed recovery rate, interpretation, or behavior
- Recovery from slow fields is usually slower than recovery from fast fields
- Fast field changes do not automatically change slow field values

---

## 6. Buffer and compensator collapse

A special case of update source.

Buffer collapse ≠ raw pressure increase.

When a compensator (hope, safety, control, perceived support, trust in provider) collapses:
- the underlying chronic load was already there
- it was being masked or managed by the buffer
- when the buffer disappears, the load becomes visible
- the apparent severity may jump even without a new event

Behavioral signals:
- mood may crash suddenly
- tolerance may drop suddenly
- the person may look as if something "broke" even though the chronic load did not increase — it was revealed

---

## 7. Memory-triggered reinstatement

A field may shift because a current cue reactivated an old imprint.

This means:
- a present cue is mild but matches an old strong imprint
- the imprint brings back the old state pattern partially or fully
- the apparent severity of the current moment may not match the objective weight of the cue alone

This is why the same objective event can produce very different reactions in the same person at different times.

---

## 8. Relation-specific update rules

### Trust
- Builds slowly through consistent follow-through under pressure
- Breaks faster than it builds
- Requires behavioral evidence to rebuild, not just words
- Inertia: once trust is broken, it takes sustained effort to rebuild

### Resentment
- Builds from perceived unfairness, broken promises, dismissals
- Does not erase when the event is over — has strong inertia
- Requires specific acknowledgment + matching repair to reduce
- Reducing resentment is usually harder than building it

### Affinity
- Most volatile — can shift relatively quickly in either direction
- Builds from positive contact, warmth, shared moments
- Reduces from coldness, perceived misuse, indifference
- Can act as buffer for trust or resentment issues

---

## 9. Non-linearity and combination effects

Same principle as STATE_MODEL:

- Multiple aligned pressures produce stronger-than-additive appraisal distortion
- Crossing a band boundary matters more than a small delta inside the same band
- Combination effects near upper bands become non-linear

Examples:
- high stress + low trust + low clarity → disproportionate narrowing of interpretation
- high resentment + another betrayal → may produce jump larger than the sum of parts
- high affinity + repair attempt → softening faster than either alone would suggest
- high fatigue + high stress → recovery is slower even after relief

---

## 10. What Run DM must not do

- Do not update fields without a behavioral or meaningful cue
- Do not skip the appraisal step
- Do not treat story convenience as sufficient cause for field changes
- Do not let a "dramatic scene" substitute for behavioral grounding
- Do not erase resentment without specific acknowledgment having happened
- Do not increase trust from words alone without behavior
- Do not treat fast field changes as automatically changing slow fields
- Do not claim a field update happened when the character did not notice or appraise the cue
- Do not use field updates as reward/punishment for narrative pacing
