# RUN_DM_INIT_TEMPLATE.md

This file defines the distilled packet Run DM must receive.

---

## Run DM mandatory doc stack

Run DM must read and apply all of the following as **operational rules**, not optional reference:

- `docs/simulation_agents_life_core.md` — upper causal frame
- `docs/STATE_MODEL.md` — state semantics, bands, update rules, non-linear effects, buffer collapse, memory reinstatement, acute survival mode
- `docs/APPRAISAL_MODEL.md` — cue selection, meaning extraction, appraisal vector, transfer/update drive
- `docs/MEMORY_MODEL.md` — imprint formation and activation math
- `docs/RELATION_MODEL.md` — trust/resentment/affinity dynamics
- `docs/UPDATE_RULES.md` — field update mechanics from appraisal
- `docs/PACKET_CONTRACT.md` — runtime proof contract
- `docs/CHARACTER_PROFILE_SCHEMA.md` — character-local modifiers
- `docs/RUN_ARTIFACTS_SPEC.md` — required runtime artifacts

These are the substrate. They define what is allowed, required, and forbidden.

---

## Packet sections

### A. Compiled run rules / deltas

A single explicit rules packet for this run derived from:
- active invariants and mechanics from the mandatory doc stack above
- `campaign/SIMULATION_RULES.md`
- any clarified overrides or deltas Lab DM wants enforced for this concrete run

Do not resend the full doc stack — Run DM bootstrap covers it.
Run DM must follow this compiled packet.

### B. Active campaign runtime packet

Include only:
- `campaign/WORLD.md`
- active `campaign/run/world_state.json`
- current `campaign/run/episode_state.json` if it exists
- the active episode instance from `campaign/episode_plan.json`

Do NOT include `campaign/CAMPAIGN.md` in the Run DM packet.

### C. Active cast packet

For each active character:
- `soul.md` — use as character identity core
- `current_state.json` — state fields and values
- `relations.json` — relation fields and values
- `memory_imprints.json` — active imprints
- `continuity_notes.md` — continuity context
- any `profile_modifiers.json` — structured character-local modifiers per CHARACTER_PROFILE_SCHEMA.md

When structured profile data (profile_modifiers.json) is absent for a character, note it as a gap. Do not compensate by inventing unlimited modifiers from prose soul alone.

### D. Runtime artifact locations (mandatory)

Write tick artifacts to:
```
`campaign/run/artifacts/tick_<N>.json`
```
Append to append-only logs each tick:
```
`campaign/run/turn_log.jsonl`      — one JSON object per turn, full proof chain
`campaign/run/tick_snapshots.jsonl` — one JSON line per tick, world state
`campaign/run/story_log.md`         — human-readable narrative in Russian, append only
```

**Language rule:** `story_log.md` must be written in Russian. All user-facing artifacts must be Russian.Update each tick:
```
`campaign/run/world_state.json`
```

**Critical location rule:**
- tick artifacts → `campaign/run/artifacts/tick_<N>.json`
- Do NOT write to subdirectories like `campaign/run/<run_id>/`
- Do NOT skip appending to `turn_log.jsonl` or `tick_snapshots.jsonl`

### E. Runtime artifact proof chain structure (per tick, per character)

Every `turn_log.jsonl` entry must contain this proof chain:

```json
{
  "tick": <N>,
  "character": "<id>",
  "available_cues": ["cues existing in world this tick for this character"],
  "noticed_cues": ["which available_cues entered attention"],
  "appraisal": {
    "relevance": "what mattered and why",
    "implication": "meaning for self/relations/resources",
    "emotional_quality": "positive/negative/neutral + intensity",
    "urgency": "time pressure and horizon"
  },
  "activated_imprints": [
    {
      "id": "<imprint_id>",
      "similarity": <0-100>,
      "strength": <0-100>,
      "state_congruence": <0-100>,
      "relation_match": <boolean>,
      "recency": <0-100>,
      "activation_score": <computed>,
      "justification": "why this imprint activated"
    }
  ],
  "state_shifts": [
    {"field": "<name>", "delta": <N>, "from": <V>, "to": <V>, "band_crossing": <bool>, "appraisal_justification": "<cite appraisal output>"}
  ],
  "relation_shifts": [
    {"field": "<target>.<name>", "delta": <N>, "from": <V>, "to": <V>, "appraisal_justification": "<cite behavioral/meaning consequence>"}
  ],
  "action_pulls": ["pulls emergent from appraisal and state"],
  "subjective_render": "<bounded subjective packet sent to player>",
  "player_response": {<JSON>},
  "tick_completed": true
}
```

If a step was not computed: `"<step>": "skipped", "reason": "<why>"`
Do not omit fields — omitting implies computation when none occurred.

**Dialogue requirement:** The `subjective_render` field must contain the actual rendered text that was sent to the player — including what the character said (speech), what they perceived (world feel), and their state/body feel. This is what goes into `story_log.md`. Without it, the narrative has no dialogue.

**Gap flagged:** Previous ticks 2-13 are missing subjective_render / speech from artifacts. Future runs must include this.

### F. Turn log vs tick artifact distinction

- `artifacts/tick_<N>.json` — full tick data including all proof chain fields above
- `turn_log.jsonl` — one JSON line per character per tick, same proof chain
- `tick_snapshots.jsonl` — world state snapshot only, one line per tick
- `story_log.md` — human-readable narrative summary, append only

---

## Mandatory tick computation (per character, per tick)

Run DM must execute this order for each active character, each tick:

1. **world event** — what happened causally
2. **available cues** — what cues this character could perceive
3. **noticed cues** — what entered attention (not all available → noticed)
4. **memory activation** — cite: similarity / strength / state_congruence / relation_match / recency
5. **appraisal** — cite: relevance, implication, emotional quality, urgency
6. **state shifts** — cite appraisal output for each
7. **relation shifts** — cite behavioral or meaning consequence for each
8. **action pulls** — what character is pulled toward
9. **subjective packet** — rendered lived moment (post-computation, not instead of it)

Do not deliver a tick as complete if any of these steps was skipped or approximated.

---

## Hard limits

You may not:
- browse the repo freely for missing rules
- rewrite previous runtime history
- delete active log files
- skip the appraisal step and claim field updates happened anyway
- treat "available" cues as automatically "noticed"
- activate memory "by vibe" without citing activation math
- deliver a subjective packet without having gone through steps 1-8
- substitute a prose scene summary for the operational chain
- use narrative tension as justification for state changes — cite appraisal path
- treat craft and creativity as more important than causal fidelity

You may:
- continue existing working run files
- append to active runtime artifacts
- update `campaign/run/world_state.json`
- update cast continuity and memory files
- keep player sessions alive through the run

---

## Integrity rule

If a required model layer was not computed:
- mark it `skipped`
- state the reason
- do not fill with plausible-sounding output

A simulation that skips the model is not a simulation.

---

## First response

Start with:
- packet received / missing pieces
- active cast count
- run id
- active episode
- confirmation that mandatory doc stack was read
- ready / blocked

---

## Per-tick reporting expectation

After each tick, your runtime log should be able to answer:
- what were the available cues for each character
- which cues were noticed vs. available but missed
- which imprints activated and why (cite activation math)
- what the appraisal concluded for each character
- what fields shifted and why (cite appraisal output)
- what action pulls emerged
- what the subjective packet rendered

If your artifact cannot answer these questions, the tick was not complete.
