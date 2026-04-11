# CALIBRATION_SCENARIOS.md — baseline scenario checks for the model

This file is a calibration set.
Its purpose is to test whether Run DM applies the mechanics consistently rather than improvising by taste.

Use together with:
- `docs/APPRAISAL_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/PACKET_CONTRACT.md`

## How to use

For each scenario, the exact numeric output may vary slightly by character profile and current state.
What matters is:
- cue selection order
- appraisal direction
- which fields move and which do not
- whether the reaction is proportionate
- whether forbidden shortcuts are avoided

## 1. Broken promise without acknowledgment

Situation:
- A promised resource return does not happen.
- The person arrives late and empty-handed.
- No explanation and no acknowledgment.

Expected:
- noticed cues: delay, empty-hands, missing acknowledgment
- appraisal: high `unfairness_betrayal`, moderate `loss_deprivation`, lower `warmth_safety`
- state: mood down, stress up
- relation: trust down, resentment up
- memory: if similar prior imprint exists, activation likely

Wrong output:
- trust unchanged
- major trust repair from words that never happened
- pure mood shift with no relational update

## 2. Delay with believable explanation and visible effort

Situation:
- A person returns late, but visibly exhausted, carrying part of what was promised, and names the failure directly.

Expected:
- noticed cues: lateness, visible effort, partial follow-through, acknowledgment
- appraisal: some burden / deprivation remains, but betrayal lower than case 1
- state: mild disappointment or stress, not a dramatic collapse
- relation: trust may soften only slightly or remain stable; resentment limited

Wrong output:
- same output as unexplained lateness
- strong resentment jump despite visible costly effort and acknowledgment

## 3. Repeated minor failures

Situation:
- Three small reliability failures happen across several ticks.
- None alone is severe.

Expected:
- accumulation matters
- appraisal shifts from mild concern to pattern-recognition
- trust drifts down, resentment builds gradually
- memory formation more likely by repetition than by any one spike

Wrong output:
- each event treated in isolation with full reset
- no relation accumulation at all

## 4. Generic apology without behavioral repair

Situation:
- After a serious breach, the person says “sorry” and wants to move on.
- No specific acknowledgment, no behavior change.

Expected:
- slight warmth effect possible if relationship is already positive
- trust should not meaningfully rebuild
- resentment should not meaningfully drop after a major breach

Wrong output:
- large trust recovery from apology alone
- resentment erased because the scene looks like reconciliation

## 5. Specific acknowledgment plus matching repair

Situation:
- The breaching person names exactly what they did wrong,
- recognizes the cost,
- performs follow-through under cost.

Expected:
- noticed cues: acknowledgment, specificity, costly repair
- appraisal: warmth/safety up, unfairness down, control/coherence up
- relation: resentment reduction possible, trust recovery possible but not instant full restoration

Wrong output:
- no relation shift at all
- immediate full reset to pre-breach trust

## 6. Mild present cue matching a strong old betrayal imprint

Situation:
- The present cue is objectively mild,
- but it strongly resembles a past betrayal pattern.

Expected:
- activated imprint visible in packet
- appraisal stronger than objective cue alone would justify
- possible partial state reinstatement
- relation read sharpens if the same target or role is involved

Wrong output:
- no memory influence despite explicit strong match
- full present collapse with no surfaced memory mechanism

## 7. Warm support during high stress

Situation:
- Character is stressed and tired.
- Another person offers calm, concrete support without pressure.

Expected:
- warmth/safety cue should land if noticed
- mood may rise faster than stress falls
- affinity may rise faster than trust
- support may buffer but not erase chronic pressure instantly

Wrong output:
- total reset of stress from one warm moment
- no effect at all despite good trust / affinity context

## 8. Buffer collapse without a new big event

Situation:
- A character learns that a relied-on support source will no longer be available.
- No bodily attack or dramatic external event occurs.

Expected:
- compensator collapse logic applies
- mood may crash immediately
- stress may rise moderately or become more behaviorally visible
- acute mode possible only if the support truly functions as survival support for this character

Wrong output:
- “nothing happened” because there was no direct action
- giant shift with no support-collapse reasoning surfaced

## 9. High pain with low mobility

Situation:
- Character is already in pain and movement is difficult.
- A task opportunity appears.

Expected:
- pain and mobility meaningfully constrain action pulls
- motivation may exist, but practical cost should rise sharply
- request-for-help / staying put / conserving effort become more plausible pulls

Wrong output:
- full normal mobility behavior with decorative pain only

## 10. Low trust under low stress vs high stress

Situation:
- Same ambiguous behavior from the same low-trust person.
- Compare one calm state and one highly stressed state.

Expected:
- under low stress: guarded but more conditional interpretation
- under high stress: sharper negative read, less patience, faster protective pulls

Wrong output:
- identical read regardless of state

## 11. Affinity without trust

Situation:
- Character likes someone and warms to them,
- but that person has failed reliability before.

Expected:
- affinity can produce softer tone and approach tendencies
- trust should remain conditionally low unless real reliability evidence appears

Wrong output:
- affinity automatically restoring trust

## 12. Acute survival mode entry / exit

Situation:
- Character experiences credible survival-support collapse.
- Later receives partial reassurance.

Expected:
- entry only if acute score criteria are met
- narrowed attention and emergency pulls while active
- exit only after threat meaning truly loosens across more than one tick

Wrong output:
- acute mode used as generic drama amplifier
- immediate entry and exit from single flavor cues with no sustained meaning
