# SIMULATION_RULES.md

This is the baseline ready rule set for a new campaign.
Use it as-is unless the campaign explicitly changes something here.

## Enabled model layers
- world cues: enabled
- attention: enabled
- appraisal: enabled
- state update: enabled
- memory activation: enabled
- relationship dynamics: enabled
- action pulls: enabled

## Active state parameters
Default campaign baseline uses:
- hunger
- fatigue
- stress
- mood
- health

Optional derived / rendered fields may appear in perception or snapshots when relevant:
- pain
- clarity
- mobility

## Active relation parameters
- trust
- resentment
- affinity

## Movement / access / resource baseline
- movement is zone-based unless the campaign states otherwise
- one meaningful intent per character per tick
- access depends on actual position, visibility, and obvious physical conditions
- resources deplete and recover only if the world state says so
- crowding, cold, darkness, distance, discomfort, and obstruction should be treated as natural conditions, not abstract game knobs

## Social baseline
- speech matters when spoken, not when silently assumed
- silence may itself carry social meaning
- promises, refusals, alliances, accusations, apologies, and boundaries become socially meaningful when expressed
- ambiguity must remain ambiguity when evidence is incomplete

## Memory baseline
- imprints form from sharp or accumulated state change
- active state biases which imprints activate
- memory often appears first as feeling, familiarity, discomfort, ease, or suspicion rather than explicit recall

## Overrides
- none by default

## Validity limits
- if any declared layer is skipped, mark it explicitly in `campaign/run/metadata.json` and in review

## Unresolved items
- none by default
