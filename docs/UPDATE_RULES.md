# UPDATE_RULES.md — how state and relations update

This document defines the transfer mechanics for both state fields and relation fields.
It complements `STATE_MODEL.md`, `RELATION_MODEL.md`, and `MEMORY_MODEL.md` with the mechanics of how changes actually happen.

Use together with:
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/CHARACTER_PROFILE_SCHEMA.md`
- `docs/PACKET_CONTRACT.md`

## 1. The core update principle

No field updates from a raw world event.
A field updates only after:

**world event → available cues → noticed cues → activated memory / relation hooks → appraisal → field shift**

Run DM must preserve this order.

## 2. When appraisal becomes a field update

Not every appraisal leads to a field update.
A field shift happens when:
1. the cue was noticed and appraised as meaningful by the character
2. the appraisal carried sufficient weight for this character at this moment
3. the resulting shift is large enough to cross a meaningful threshold or accumulate with existing pressure

A field may update when:
- an event has sufficient weight for this character
- an accumulated pattern has reached a threshold
- a buffer or compensator collapsed
- a memory imprint was activated that shifted the felt state
- an acute regime switched on or off

## 3. Update sources

### 3.1 State fields update from
- immediate bodily/environmental signal
- accumulated strain over several ticks
- sharp spike or shock
- memory-triggered state reinstatement
- buffer/compensator collapse
- acute regime switch

### 3.2 Relation fields update from
- concrete behavior or its absence
- timing
- visible effort or its absence
- acknowledgment or dismissal
- repair attempt or failure to repair
- fairness in burden or resource sharing
- warmth or coldness in tone or contact
- exposure or misuse of vulnerability

## 4. Default update math

### 4.1 Generic raw shift formula

For any field:

```text
raw_shift =
  drive *
  susceptibility *
  source_strength *
  band_multiplier *
  combo_multiplier *
  inertia_multiplier *
  evidence_multiplier
```

Where:
- `drive` comes from appraisal dimensions mapped to that field
- `susceptibility` comes from the character profile
- `source_strength` reflects cue strength and whether this is direct signal, accumulation, or memory reinstatement
- `band_multiplier` becomes steeper near critical bands
- `combo_multiplier` amplifies aligned simultaneous pressures
- `inertia_multiplier` represents stickiness or worsening bias of the current field
- `evidence_multiplier` mainly matters for relation updates and discounts weak evidence

### 4.2 Point conversion

```text
if raw_shift < 0.08:
  delta_points = 0
else:
  delta_points = round(25 * raw_shift ^ 1.15)
```

Default magnitude interpretation:
- slight: `1..5`
- moderate: `6..12`
- major: `13..25`

The magnitude tier is derived from `raw_shift`, not chosen narratively.

### 4.3 Direction

Each update must state direction explicitly:
- worsening pressure field → `+`
- relieving pressure field → `-`
- worsening capacity field → `-`
- improving capacity field → `+`
- trust gain → `+`
- resentment gain → `+`
- affinity gain → `+`

## 5. Field-specific default speed rules

### 5.1 Fast-reactive fields
May shift from single events:
- mood
- pain
- acute arousal / buffers / temporary support feelings
- affinity

### 5.2 Slow-accumulating fields
Change gradually and have more inertia:
- stress
- fatigue
- hunger
- health
- trust
- resentment

Practical rule:
- a single event may sharply move mood but barely touch stress
- the same event may later influence slower fields through changed recovery rate, interpretation, or behavior

## 6. Band multipliers and non-linearity

Crossing a band boundary matters more than a small delta inside the same band.

Default heuristic:
- band 0 → `0.90`
- band 1 → `1.00`
- band 2 → `1.08`
- band 3 → `1.18`
- band 4 → `1.30`

Apply the current band of the affected field.
If the shift crosses into a worse band, apply a small additional crossing bonus up to `+0.10` raw equivalent.

## 7. Inertia and recovery resistance

### 7.1 Pressure fields
- already-high stress rises more easily and falls more slowly
- already-high fatigue keeps reducing recovery bandwidth
- already-high resentment resists reduction strongly

### 7.2 Capacity fields
- already-low clarity is easier to reduce further under aligned pressure
- already-low mood discounts positive signals
- already-low mobility makes additional costs matter more

### 7.3 Default multipliers

For worsening in a bad current band:
- `1.05..1.35`

For recovery in a bad current band:
- `0.65..0.95`

Use stronger resistance for:
- resentment reduction
- trust rebuilding after major breach

## 8. Buffer and compensator collapse

A special update source.

Buffer collapse is not the same as a raw pressure increase.
When a compensator collapses:
- the underlying chronic load was already there
- it was being masked or managed by the buffer
- when the buffer disappears, the load becomes visible
- apparent severity may jump even without a new large objective event

Examples of buffers:
- hope
- perceived support
- perceived control
- trust in provider
- belief in near-term relief

## 9. Memory-triggered reinstatement

A field may shift because a current cue reactivated an old imprint.

Rules:
- the cue must match a meaningful imprint
- the imprint activation must be visible in the packet
- reinstatement may amplify or bias the present update
- reinstatement must not replace the current cue set entirely

Default source strength guidance:
- light activation: `0.9`
- meaningful activation: `1.0`
- partial reinstatement: `1.1..1.25`

## 10. Acute regime switch

When acute survival mode turns on:
- stress drive is amplified
- clarity reduction becomes easier
- attention capacity reduces
- protective / emergency action pulls get boosted

When the mode turns off:
- do not fully erase existing stress or resentment
- only remove the regime bonus and allow ordinary recovery rules again

## 11. Relation-specific update rules

### 11.1 Trust
- builds slowly through consistent follow-through under pressure
- breaks faster than it builds
- requires behavioral evidence to rebuild, not just words
- repeated small failures stack into major breaks

### 11.2 Resentment
- builds from perceived unfairness, broken promises, dismissals
- does not erase when the event is over
- reducing resentment is usually harder than building it
- requires specific acknowledgment plus matching repair

### 11.3 Affinity
- most volatile relation field
- positive moments can move it faster than trust
- warmth does not automatically repair trust or erase resentment

## 12. Update significance in logs

A shift is significant enough to expose explicitly when at least one is true:
- it crosses a band boundary
- it changes attention bias or appraisal direction
- it changes available action pulls
- it changes the read of another person
- it contributes to memory formation
- it activates or deactivates acute survival mode

## 13. What Run DM must not do

- do not update fields without a noticed and appraised cue
- do not skip the appraisal step
- do not treat story convenience as sufficient cause for field changes
- do not let a dramatic scene substitute for behavioral grounding
- do not erase resentment without specific acknowledgment having happened
- do not increase trust from words alone without behavior
- do not treat fast field changes as automatically changing slow fields
- do not claim a field update happened when the character did not notice or appraise the cue
- do not use field updates as reward/punishment for narrative pacing
