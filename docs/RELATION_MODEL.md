# RELATION_MODEL.md — relation dynamics

## Status
This is a first draft. Needs elaboration.

## Core fields

### trust (higher = more trust)
Meaning: expectation of reliable, safe, honest follow-through.
Likely influenced by: observed reliability, promises kept or broken, timing, visible effort.

### resentment (higher = more resentment)
Meaning: accumulated grievance, friction, readiness to interpret negatively.
Likely influenced by: broken promises, dismissals, unfairness, perceived exploitation.

### affinity (higher = more warmth)
Meaning: felt warmth, pull toward closeness or softening.
Likely influenced by: shared moments, repair attempts, positive contact, mutual effort.

## Band semantics

Default bands 0..100, same as state fields:
- 0..19: critical — deep grievance or complete withdrawal
- 20..39: strong negative — significant friction
- 40..59: moderate — mixed, conditionally stable
- 60..79: positive — workable trust
- 80..100: strong — solid relational foundation

## How relations update

See UPDATE_RULES.md.

## Cross-effects with state

- High stress + low trust -> sharper negative reads, faster grievance
- Low trust + positive event -> harder to accept, possible suspicion of manipulation
- High affinity + repair attempt -> easier softening
- High resentment + another betrayal -> non-linear jump

## Character-local modifiers

Same principle as state model:
- generic relation meanings and bands are shared across characters
- character-local modifiers determine sensitivity, repair style, threshold for trust/repair
- modifiers do NOT redefine the generic meaning of the number

## Memory effects on relations

See MEMORY_MODEL.md.

Imprints with strong relational content (broken promise, repair, humiliation, warmth) can shift relation state faster than gradual drift alone.

## What Run DM must not do

- Do not let relation values change without behavioral or meaningful cue
- Do not use relation changes as reward/punishment for story
- Do not make trust increase from words alone without corresponding observed behavior
