# REVIEW_TEMPLATE.md

The produced review file should usually be named `review_summary.md` and should be written in **Russian**.
This template is written in English only as an internal guide.

## 1. Run identity
- campaign:
- run_id:
- date:
- reviewer:

## 2. Validity
- valid_for_model_testing:
- validity_reason:

## 3. Model layers

```json
{
  "model_layers": {
    "world_cues": { "used": true, "updated": true },
    "attention": { "used": true, "updated": true },
    "appraisal": { "used": true, "updated": true },
    "state_update": { "used": true, "updated": true },
    "memory_activation": { "used": true, "updated": true },
    "relationship_dynamics": { "used": true, "updated": true },
    "action_pulls": { "used": true, "updated": true }
  }
}
```

## 4. Model integrity
- where the causal chain held
- where it broke
- whether any layer was silently omitted

## 5. Environment usage
- whether the environment was actually used
- whether affordances / constraints mattered
- whether the run drifted into empty talk detached from the world

## 6. Causality and agency
- whether DM replaced characters
- whether hidden repositioning or hidden intention assignment happened
- whether the between-tick logic remained readable

## 7. Memory and continuity
- whether memory was activated meaningfully
- whether memory effects were plausible
- whether continuity held or degraded

## 8. Agent quality
- whether player agents felt alive or over-rationalized
- whether Run DM rendered subjectivity honestly instead of smoothing it away

## 9. Failures
- concrete failures

## 10. Improvements
- what to change before the next run
- which templates / rules / docs need clarification
