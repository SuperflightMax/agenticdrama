# CHARACTER_PROFILE_SCHEMA.md — explicit character-local modifiers

This document defines the minimal explicit schema for character-local response profiles.
Its purpose is to stop important character mechanics from living only in vague prose.

Use together with:
- `docs/STATE_MODEL.md`
- `docs/RELATION_MODEL.md`
- `docs/APPRAISAL_MODEL.md`
- `docs/UPDATE_RULES.md`

## 1. Why this exists

The shared state and relation scales must stay comparable across characters.
So a character profile must not redefine what `stress = 70` or `trust = 40` means.

Its job is to define:
- what this character notices faster or slower
- what hits harder or softer than average
- what repairs them or fails to repair them
- how relations harden or soften for them

## 2. Minimal schema

```json
{
  "notice_biases": {
    "threat": 1.20,
    "resource_loss": 1.35,
    "warmth": 0.90
  },
  "appraisal_sensitivities": {
    "threat": 1.10,
    "burden": 0.95,
    "loss_deprivation": 1.25,
    "unfairness_betrayal": 1.30,
    "warmth_safety": 0.85,
    "control_coherence": 1.15
  },
  "state_susceptibilities": {
    "stress": 1.20,
    "fatigue": 0.90,
    "mood": 1.10,
    "clarity": 1.15,
    "pain": 1.00,
    "mobility": 0.95
  },
  "relation_modifiers": {
    "trust_break_speed": 1.20,
    "trust_rebuild_speed": 0.75,
    "resentment_build_speed": 1.25,
    "resentment_release_speed": 0.70,
    "affinity_volatility": 1.10
  },
  "recovery_style": {
    "responds_to_visible_followthrough": 1.35,
    "responds_to_warmth": 0.80,
    "responds_to_explanation": 0.90,
    "responds_to_solitude": 1.15,
    "responds_to_task_completion": 1.20
  },
  "acute_profile": {
    "acute_trigger_sensitivity": 1.10,
    "preferred_emergency_pulls": ["freeze", "cling", "control"],
    "acute_exit_resistance": 1.15
  }
}
```

## 3. Value interpretation

Default multiplier interpretation:
- `1.00` = average
- `0.85..0.95` = mildly reduced
- `1.05..1.15` = mildly elevated
- `1.16..1.30` = strong
- `> 1.30` = should be used sparingly and only when strongly justified

Avoid cartoonish extremes.

## 4. Required sections

### 4.1 Notice biases
What enters attention faster for this character.
Examples:
- threat cues
- timing failures
- warmth signals
- resource cues
- authority cues

### 4.2 Appraisal sensitivities
What kinds of meaning hit harder once noticed.
Examples:
- betrayal sensitivity
- deprivation sensitivity
- control-loss sensitivity
- shame / humiliation sensitivity if the campaign later formalizes it

### 4.3 State susceptibilities
How readily appraisal drives specific state fields.
Examples:
- stress rises quickly
- pain cuts clarity hard
- mood recovers poorly
- fatigue accumulates slowly

### 4.4 Relation modifiers
How this character's relations change.
Examples:
- trust breaks quickly
- resentment sticks
- affinity warms fast but cools fast too

### 4.5 Recovery style
What actually helps.
Examples:
- visible follow-through
- warmth
- explicit explanation
- solitude
- concrete action completion

### 4.6 Acute profile
How acute survival mode behaves for this character.
Examples:
- triggers relatively easily around dependency collapse
- tends toward freeze or control rather than attack
- exits slowly even after partial reassurance

## 5. Source of truth rule

If a character-local modifier matters repeatedly for outcomes and is not explicit anywhere reliable,
Lab DM should add it to cast materials instead of leaving Run DM to freestyle it forever.

## 6. What not to put here

Do not put:
- decorative personality prose with no mechanical implication
- a second hidden state system
- direct action decisions like “always attacks when angry”
- hidden redefinitions of the shared numeric bands

This schema influences perception, appraisal, shift, recovery, and pull strength.
It does not replace choice.
