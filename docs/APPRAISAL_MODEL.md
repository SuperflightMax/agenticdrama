# APPRAISAL_MODEL.md — cue selection, meaning extraction, and update drive

This document defines how Run DM turns world events into noticed cues, how those cues are appraised,
and how appraisal becomes update pressure for state and relations.

Use together with:
- `docs/simulation_agents_life_core.md`
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/MEMORY_MODEL.md`
- `docs/UPDATE_RULES.md`
- `docs/CHARACTER_PROFILE_SCHEMA.md`
- `docs/PACKET_CONTRACT.md`

## 1. Core rule

Appraisal is the center of the model.
No state or relation field may update from a raw world event alone.
The order is:

**world event → available cues → noticed cues → activated memory / relation hooks → appraisal vector → update pressure**

If this layer is skipped, the run is invalid.

## 2. Cue model

A cue is the smallest meaningful piece of the current situation that can enter attention and appraisal.

### 2.1 Minimal cue schema

```json
{
  "id": "cue_017",
  "type": "social_delay",
  "source": "p2",
  "target": "p1",
  "intensity": 0.55,
  "duration": 0.40,
  "certainty": 0.70,
  "visibility": 0.90,
  "domains": ["reliability", "resource", "fairness"],
  "tags": ["promise", "food", "late_return"]
}
```

### 2.2 Required cue properties

- `type` — what kind of signal it is
- `source` / `target` — who emitted it and who it matters to
- `intensity` — how strong the signal is
- `certainty` — how ambiguous or well-established it is
- `visibility` — how available it is to this observer
- `domains` — what kinds of meaning it can activate
- `tags` — concrete situation hooks

## 3. Notice step

Not all available cues are noticed.
Run DM must compute a noticed subset.

### 3.1 Notice inputs

Use normalized values in `0..1`:
- `intensity`
- `visibility`
- `goal_relevance`
- `state_match`
- `novelty`
- `capture_bonus`

Where:
- `goal_relevance` is how much the cue matters to current needs / live concerns
- `state_match` is how much current state makes this cue pop
- `capture_bonus` is for severe pain, direct danger, strong relational breach, or similar foreground-grabbing cues

### 3.2 Default notice formula

```text
notice_score =
  0.25 * intensity +
  0.20 * visibility +
  0.20 * goal_relevance +
  0.15 * state_match +
  0.10 * novelty +
  0.10 * capture_bonus
```

### 3.3 Notice rules

- default notice threshold: `0.35`
- keep top `3..5` noticed cues per character per meaningful tick
- in acute survival mode, keep top `2..3`
- cues below threshold may still remain latent context but should not drive major updates directly

## 4. Appraisal vector

Appraisal should not be a vague single mood word.
Use a compact vector of dimensions.

### 4.1 Default appraisal dimensions

Use normalized `0..1` values:
- `threat`
- `burden`
- `loss_deprivation`
- `unfairness_betrayal`
- `warmth_safety`
- `control_coherence`

Campaigns may add dimensions only if the base six cannot express a recurring required distinction.

### 4.2 Meaning of the axes

- `threat` — danger, hostility, imminent harm, unsafe ambiguity
- `burden` — effort cost, strain, demand load, exhaustion pressure
- `loss_deprivation` — scarcity, withholding, absence of expected support/resource
- `unfairness_betrayal` — violation of expectation, asymmetry, misuse, broken follow-through
- `warmth_safety` — comfort, support, trustable presence, soothing contact
- `control_coherence` — ability to make sense, predict, and act effectively

## 5. Per-cue appraisal contribution

Each noticed cue contributes to one or more appraisal dimensions.

### 5.1 Inputs

Use normalized values in `0..1`:
- `cue_base`
- `notice_score`
- `certainty`
- `character_sensitivity`
- `state_modifier`
- `relation_modifier`
- `memory_modifier`

### 5.2 Default per-dimension formula

```text
cue_contribution(dim) =
  cue_base(dim) *
  notice_score *
  certainty *
  character_sensitivity(dim) *
  state_modifier(dim) *
  relation_modifier(dim) *
  memory_modifier(dim)
```

Rule:
- `cue_base(dim)` is derived from cue type and domains
- `character_sensitivity(dim)` comes from the character profile
- `state_modifier(dim)` reflects current state bands and biases
- `relation_modifier(dim)` matters mostly on interpersonal cues
- `memory_modifier(dim)` applies when activated imprints match the cue

## 6. Combining cue contributions into the appraisal vector

For each dimension:

```text
appraisal_dim = clamp(sum(cue_contribution(dim) for noticed cues), 0, 1)
```

Then compute a combination multiplier for aligned pressures.

### 6.1 Combination multiplier

Aligned high-pressure combinations should matter more than pure addition.

Default:

```text
combo_multiplier = 1 + 0.25 * aligned_pressure_count
```

Where `aligned_pressure_count` counts severe simultaneous pressures such as:
- `threat >= 0.60`
- `unfairness_betrayal >= 0.60`
- `loss_deprivation >= 0.60`
- `control_coherence <= 0.35` interpreted as control failure

Cap default `combo_multiplier` at `1.75`.

## 7. Appraisal → update drive

The appraisal vector does not directly choose action.
It creates update pressure for state and relations.

### 7.1 Default state drive mapping

- `threat` → stress `+`, clarity `-`, possible acute score `+`
- `burden` → fatigue `+`, mood `-`
- `loss_deprivation` → hunger `+` when resource-linked, mood `-`, stress `+`
- `unfairness_betrayal` → mood `-`, stress `+`, relation update pressure
- `warmth_safety` → stress `-`, mood `+`, sometimes clarity `+`
- `control_coherence` high → clarity `+`, stress `-`
- `control_coherence` low / collapse → clarity `-`, stress `+`

### 7.2 Default relation drive mapping

- broken follow-through / reliability failure → trust `-`, resentment `+`
- fairness breach → resentment `+`, affinity `-` sometimes
- warmth / soft support → affinity `+`, sometimes trust `+`
- specific acknowledgment + repair → resentment `-`, trust `+`
- coldness at a vulnerable moment → affinity `-`, resentment `+`

## 8. Appraisal weight

For logging and thresholding, compute an overall appraisal weight.

```text
appraisal_weight =
  max(threat, burden, loss_deprivation, unfairness_betrayal, warmth_safety, 1 - control_coherence)
  * combo_multiplier
```

Clamp the final weight to `0..1` after multiplier application.

Interpretation:
- `< 0.20` → negligible
- `0.20..0.39` → slight
- `0.40..0.64` → meaningful
- `0.65..0.84` → strong
- `0.85+` → severe / regime-risk

## 9. What must be shown in the packet

Run DM must not merely say “the character felt bad”.
The packet must show:
- which cues were noticed,
- which imprints activated,
- the resulting appraisal vector,
- which fields were driven by which dimensions.

Detailed output format is defined in `docs/PACKET_CONTRACT.md`.

## 10. Anti-patterns

Do not:
- skip the notice step and appraise every available cue equally
- collapse all appraisal into one mood word
- use “the scene feels tense” as a substitute for cue-derived appraisal
- claim memory influenced appraisal without showing which imprint activated
- update relations from state alone when no relationally meaningful cue was appraised
- use appraisal language as narrative decoration if no mechanics are attached
