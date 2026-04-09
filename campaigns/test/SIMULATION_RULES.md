# SIMULATION_RULES.md

This is the active ready rule set for `trust_pressure_test`.
Use it as-is unless the campaign is explicitly edited.

## Enabled model layers
- world cues: enabled
- attention: enabled
- appraisal: enabled
- state update: enabled
- memory activation: enabled
- relationship dynamics: enabled
- action pulls: enabled

## Active state parameters
Baseline active state fields in this campaign:
- hunger
- fatigue
- stress
- mood
- health
- pain
- clarity
- mobility

## Active relation parameters
- trust
- resentment
- affinity

## Zone and movement baseline
- movement is zone-based
- one meaningful intent per character per tick
- leaving the shelter for yard / pump shed / wood lean-to usually has a mild comfort cost because of cold and mud
- characters can fail to witness actions happening in other zones
- absence, delay, and returning empty-handed are socially meaningful if noticed

## Resource baseline
- heat, water, and light are scarce enough to matter
- fetching water, carrying wood, and sorting supplies take real time and should not be hand-waved into zero-cost flavor
- using or moving a scarce shared item without saying so may create suspicion when the absence becomes visible
- no auto-restock, no hidden convenience refill unless declared in world state

## Social-meaning baseline
- spoken promises matter once they are actually spoken
- promises do not prove intent, but they create expectation and later become socially relevant if delayed, avoided, broken, or repaired
- silence, disappearing into another zone, returning with excuses, or bringing only part of what was promised can all carry meaning
- apology, repair, minimization, counter-accusation, or practical compensation must be distinguished from each other
- ambiguity must remain ambiguity when evidence is incomplete

## Promise tracking rule
When a character makes an explicit future-facing commitment, Run DM should add a pending promise record to world continuity.
A tracked promise should include:
- promiser
- receiver or affected group
- promised action / object
- soft due condition if one was spoken or strongly implied
- current status: pending / partially fulfilled / fulfilled / missed / disputed

Breaking or missing a promise does not automatically prove betrayal.
It changes social meaning through perception, relation state, and visible evidence.

## Visible effort rule
Visible, effortful contribution should matter.
If a character repeatedly does the practical work that others rely on, and that work is seen or credibly reported, it may shift trust / resentment / affinity.
Claimed effort without visible result or credible bridge should remain uncertain.

## Memory baseline
- imprints form from sharp or accumulated state change
- similar tone, delay, dismissal, or uneven effort may activate older social imprints before explicit recall occurs
- memory may appear as unease, pressure, irritation, or sudden drop in trust rather than clean recollection

## Overrides
- none beyond the campaign-specific promise / effort / scarce-item handling above

## Validity limits
- if any declared layer is skipped, mark it explicitly in `campaign/run/metadata.json` and in review
- if a run outcome depends on a missing concrete rule, stop and escalate instead of faking certainty

## Unresolved items
- none by default
