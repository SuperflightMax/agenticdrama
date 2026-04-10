# SIMULATION_RULES.md

This is the active ready rule set for `test_minimal`.

## Enabled model layers
- world cues: enabled
- attention: enabled
- appraisal: enabled
- state update: enabled
- memory activation: enabled
- relationship dynamics: enabled
- action pulls: enabled

## Active state parameters
- hunger
- stress
- mood
- fatigue

## Active relation parameters
- trust
- resentment
- affinity

## Movement / access / resource baseline
- movement is zone-based
- one meaningful intent per character per tick
- shelter comfort is limited by crowding
- berry resource depletes when taken
- being left outside while another keeps the best comfort can matter socially

## Memory
- active
- imprints are created from meaningful state shifts
- player agents receive only memory effects, not raw memory storage

## Social baseline
- speech matters when spoken
- silence may carry social meaning
- promises and refusals matter if clearly expressed

## Active environmental pressures
- mild cold / exposure discomfort
- mild hunger
- limited shelter capacity
- limited food resource
