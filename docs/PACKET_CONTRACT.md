# PACKET_CONTRACT.md — runtime proof that the model was actually used

This document defines the minimum packet / reasoning structure that Run DM must be able to produce for each meaningful tick.
Its purpose is not style. Its purpose is proof.

Use together with:
- `docs/APPRAISAL_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/RUN_ARTIFACTS_SPEC.md`

## 1. Why this exists

A run is not validated by sounding plausible.
A run is validated by showing that cues, attention, memory, appraisal, and updates were actually computed rather than handwaved.

## 2. Minimum per-tick proof object

For each meaningful tick, Run DM should be able to produce an internal proof object like this:

```json
{
  "tick": 14,
  "character": "anya",
  "available_cues": [
    {"id": "cue_011", "type": "late_return"},
    {"id": "cue_012", "type": "empty_hands"}
  ],
  "noticed_cues": [
    {"id": "cue_011", "notice_score": 0.67},
    {"id": "cue_012", "notice_score": 0.74}
  ],
  "activated_imprints": [
    {"id": "imp_004", "activation_score": 0.71}
  ],
  "appraisal": {
    "threat": 0.18,
    "burden": 0.12,
    "loss_deprivation": 0.53,
    "unfairness_betrayal": 0.61,
    "warmth_safety": 0.05,
    "control_coherence": 0.31,
    "combo_multiplier": 1.25,
    "appraisal_weight": 0.76
  },
  "state_shifts": {
    "stress": {"from": 58, "to": 66, "delta": 8, "drivers": ["unfairness_betrayal", "loss_deprivation"]},
    "mood": {"from": 47, "to": 39, "delta": -8, "drivers": ["unfairness_betrayal", "low_warmth_safety"]}
  },
  "relation_shifts": {
    "trust:nick": {"from": 61, "to": 56, "delta": -5, "drivers": ["reliability_failure"]},
    "resentment:nick": {"from": 33, "to": 40, "delta": 7, "drivers": ["unfairness_betrayal"]}
  },
  "action_pulls": [
    {"type": "confront", "weight": 0.61},
    {"type": "withdraw", "weight": 0.48},
    {"type": "verify", "weight": 0.22}
  ],
  "subjective_render": {
    "body_feel": "tight, uneasy",
    "world_feel": "less reliable, narrower",
    "thought_flashes": ["this is going bad again"]
  }
}
```

## 3. Required sections

### 3.1 available_cues
The proof must show at least the cues that mattered.
Do not pretend a cue drove the outcome if it was never enumerated.

### 3.2 noticed_cues
A cue may exist without being noticed.
If it was not noticed, it should not drive a major shift.

### 3.3 activated_imprints
If memory mattered, show which imprint activated and how strongly.

### 3.4 appraisal
The proof must expose the appraisal vector and overall weight.
A single sentence like “felt betrayed” is not enough.

### 3.5 state_shifts / relation_shifts
Each meaningful change should show:
- previous value
- new value
- delta
- at least the main drivers

### 3.6 action_pulls
The packet should show what action tendencies became live.
The player may still choose against a pull, but the pull must be visible.

### 3.7 subjective_render
This is where the math turns into lived experience.
Allowed:
- body feel
- world feel
- brief thought flashes
- local salience notes

Not allowed:
- objective facts that the character does not know
- the final decision made for the character

## 4. Where this lives in runtime artifacts

The full proof object may be:
- embedded in `turn_log.jsonl`, or
- split between `turn_log.jsonl` and `tick_snapshots.jsonl`

`story_log.md` does not need to dump this raw structure.
It is owner-facing.
But the machine-readable runtime artifacts must preserve the proof chain.

## 5. Minimum truthfulness rules

Run DM must not:
- claim that state, memory, or relations were used without showing the proof chain
- skip `noticed_cues` and jump from available world facts straight to appraisal
- claim a relation update if no relational cue was appraised
- claim memory influence if no imprint is surfaced
- omit a strong acute regime shift from the proof object

## 6. Optional compact mode

If token pressure is severe, a compact proof object is allowed,
but it must still include:
- noticed cues
- activated imprints if any
- appraisal vector summary
- state / relation deltas
- action pulls

Compactness is allowed.
Silent skipping is not.
