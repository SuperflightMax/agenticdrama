# rules.md — global simulation rules

This file defines the global baseline rules that Run DM must follow unless a campaign-specific rule explicitly overrides them.

## 1. Rule precedence

Run DM must follow rules in this order:

1. `docs/simulation_agents_life_core.md`
2. `campaign/SIMULATION_RULES.md`
3. `rules.md`
4. `protocol.md`
5. `CONVENTIONS.md`

If a campaign-specific mechanic is required for outcome resolution and is **not** declared clearly, do **not** invent it.
Flag the gap and ask Lab DM, or mark the run blocked / partial if it already started.

## 2. Global invariants

- `world_state.json` is the runtime source of truth for the current world state.
- Players do not mutate the world directly; Run DM applies consequences.
- Run DM does not choose final actions for players.
- Subjective rendering must not be presented as objective fact.
- Runtime artifacts must reflect what was actually computed, not what would have been nice to claim.

## 3. State and continuity baseline

Typical state parameters may include:
- stress
- mood
- fatigue
- health
- pain
- clarity
- mobility

Campaigns may add or remove parameters, but the active set must be declared in `campaign/SIMULATION_RULES.md`.

## 4. Relationships baseline

Typical relationship fields:
- trust
- resentment
- affinity

These are not interchangeable:
- `trust` = willingness to rely or believe
- `resentment` = accumulated hurt / grievance
- `affinity` = how pleasant or unpleasant interaction feels

Campaigns may use a subset, but the subset must be declared.

## 5. Perception baseline

State influences perception.
At minimum, Run DM should respect these tendencies unless campaign rules replace them:

- high stress narrows attention and amplifies threat reading
- low clarity or high fatigue reduces planning depth
- low mood biases appraisal toward the negative
- negative trust / high resentment biases message reading and social interpretation
- affinity changes how contact with someone feels even before explicit reasoning

Run DM may render subjective distortion, but must not turn it into world truth.

## 6. Memory baseline

Memory is not an archive.
It is a set of imprints and triggered effects.

Run DM must follow `docs/MEMORY_MODEL.md` for:
- imprint formation,
- strengthening / fading,
- trigger behavior,
- drift under charged recall.

Player agents should receive memory effects, not raw storage.

## 7. Communication and social meaning

Spoken social meaning is stronger and more binding than unspoken assumption.
Silence can itself carry meaning.

Run DM should not auto-resolve motives, alliances, promises, boundaries, apologies, or refusals unless they were actually expressed or made behaviorally clear.

## 8. Consequence resolution

Run DM applies consequences through:
- physical constraints,
- social constraints,
- declared campaign rules,
- current world state.

Do not hide a missing rule by producing a confident outcome.

## 9. Model-layer validity

For each run, and preferably per tick when relevant, track the status of major layers:
- world cues / sensing
- attention
- appraisal
- state update
- memory activation
- relationship dynamics
- action pulls

Allowed statuses:
- `used`
- `updated`
- `skipped`
- `reason`

If a critical layer was skipped, mark run validity honestly:
- `true`
- `partial`
- `false`
