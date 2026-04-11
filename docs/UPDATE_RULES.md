# UPDATE_RULES.md — how state and relations actually update

## Status
This is a first draft. Needs elaboration based on STATE_MODEL and RELATION_MODEL.

## Update trigger rule

A field updates only if:
1. the cue was available
2. the character noticed it
3. the character appraised it as meaningful

No direct world-to-state jump.

## Update sources

### State fields may shift from:
- immediate bodily/environmental signal (pain spike, cold shock, sudden relief)
- accumulated strain over several ticks
- sharp spike or shock
- memory-triggered state reinstatement
- buffer/compensator collapse
- acute regime switch (e.g., survival mode)

### Relation fields may shift from:
- concrete behavior (promise kept, promise broken, visible effort, dismissal, repair attempt, unfairness)
- timing (delay without explanation, late return, early return)
- social meaning (warmth, coldness, exclusion, inclusion)
- memory activation with relational content

## Update magnitudes

Same three-tier default as STATE_MODEL:
- slight shift: 1..5
- moderate shift: 6..12
- major shift: 13..25

Heuristics:
- first noticeable breach of trust -> usually moderate or major on resentment
- repeated same pattern without repair -> major
- visible sincere repair after long breach -> moderate on trust, slight on resentment
- one acute pain spike -> usually major on pain, may ripple to stress
- buffer collapse -> major on felt impairment even if the underlying chronic field barely moved

## Inertia

Same as STATE_MODEL:
- existing relation state has inertia
- already-high resentment rises more easily from new grievance
- already-low trust falls more easily from delay or silence
- positive signals do not automatically erase accumulated grievance

## Non-linearity

Same as STATE_MODEL:
- combination effects are stronger than additive
- band crossings matter more than small deltas inside a band
- multiple aligned pressures produce disproportionate appraisal distortion

## What Run DM must not do

- Do not update state or relations from pure story convenience
- Do not skip the appraisal step
- Do not treat a "good scene" as sufficient cause for trust increase without corresponding behavior
- Do not treat a "dramatic moment" as sufficient cause for major shifts without behavioral grounding
- If the update logic is ambiguous, mark it ambiguous instead of smoothing it over
