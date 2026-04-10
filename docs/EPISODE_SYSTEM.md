# EPISODE_SYSTEM.md

This file defines the canonical way to prepare, queue, inject, and advance situation episodes inside one campaign.

The goal is not to script outcomes.
The goal is to give Lab DM a reusable way to expose characters to meaningful situations that can create memory, relationship drift, and new appraisal patterns over time.

## 1. Why episodes exist

A campaign world may be stable, but rich development often needs **structured exposure to pressure**.
Episodes provide that pressure without replacing causality.

An episode is:
- a bounded situation frame,
- injected into the existing world,
- with explicit pressures, affordances, and unknowns,
- without forcing character conclusions or decisions.

Episodes are not story beats that must resolve a certain way.
They are **causal test situations**.

## 2. Core rule

When one episode ends and another begins:
- keep the current character state,
- keep accumulated memory and relation changes,
- keep world consequences unless the next episode explicitly overrides something,
- inject only the delta declared by the new episode.

Do **not** silently reset mood, trust, memory, fatigue, inventory, or continuity just because a new episode starts.

## 3. Canonical files

Global reusable episode library:

```text
episodes/
  <template_id>.md
  README.md
```

Each campaign should contain:

```text
campaigns/<name>/
  episode_plan.json
  run/
    episode_state.json
```

### `episodes/<template_id>.md`
Global reusable situation template.
Lab DM chooses from this library when assembling a campaign.
New reusable templates discovered during review should be added back here.

### `episode_plan.json`
Ordered list of selected episode instances for this campaign.
Each entry points to a template and adds campaign-specific concretization for the current world and cast.
Campaign-specific concretization belongs here, not in a duplicated template library under the campaign.

### `run/episode_state.json`
Working runtime tracker for the current run.
Tracks which episode is active, what has already been injected, and what remains.

## 4. Lab DM responsibility

Lab DM owns episode planning.
Lab DM should:
- choose reusable templates from `episodes/`,
- concretize them for the current world and cast,
- write the resulting queue into `campaign/episode_plan.json`,
- preserve continuity between episodes unless an override is explicit,
- add good newly discovered reusable templates back into `episodes/`.

If an older campaign still contains `campaign/episode_templates/`, treat it as legacy scratch material rather than canonical truth.

## 5. Run DM responsibility

Run DM does not own campaign planning.
Run DM may receive only:
- the active episode instance,
- the current runtime world state,
- the active cast packet,
- the current `run/episode_state.json` tracker.

Run DM does not need awareness of future queued episodes unless Lab DM explicitly includes that context for the current run.

## 6. Episode template must contain

- template id / name
- what causal pressure it introduces
- why it is useful for model testing
- required world preconditions
- suggested injection payload
- likely but non-binding consequence directions
- completion conditions
- handoff notes for next episode

## 7. Episode plan entry

Each entry in `episode_plan.json` should declare:
- `episode_id`
- `template_id`
- `title`
- `order`
- `enabled`
- `goal_of_exposure`
- `tick_budget_hint`
- `entry_conditions`
- `injection`
- `completion_signals`
- `carry_forward_notes`

Recommended injection shape for active-runtime use:
- `pressure_intent` — what new causal pressure must appear
- `compatibility_checks` — what must already be true, and what must **not** be overwritten
- `realization_hints` — allowed ways Run DM may concretize the pressure from the current runtime world
- `world_patch` — only minimal safe deltas that can be applied directly without breaking continuity
- `notes` — ambiguity, safety, and non-forcing reminders

## 8. Injection rule

An episode injection is a **targeted patch**, not a total reset.

It must be applied against the **current active runtime state** in `campaign/run/world_state.json`, not against the baseline campaign root state in `campaign/world_state.json`.

It may change only what the episode explicitly touches, for example:
- time of day,
- weather,
- a pending promise,
- a missing object,
- a new external event,
- an incoming message,
- a temporary survival pressure.

If the episode file does not declare a state field override, keep the current value from the end of the previous episode or previous tick.

Forbidden for mid-run episode injection unless explicitly justified and repair-safe:
- teleporting characters to new zones by fiat,
- declaring that a character already said or did something that has not yet happened in runtime,
- restoring earlier baseline positions or resources just because the template assumed them,
- replacing a live unresolved situation with a cleaner template start state.

If the current runtime state is incompatible with a template's preferred starting picture, do not force the picture onto the world. Instead:
- adapt the episode to the live state,
- choose another concrete realization of the same pressure,
- or delay / skip the episode and record why.

## 9. Visibility of injection

When an episode is injected:
- the causal patch itself must be visible in runtime world state / snapshots,
- `story_log.md` should contain one short human-readable note that an injection happened and what pressure was introduced,
- if speech happens in that tick, preserve direct speech verbatim in the log instead of replacing it with descriptive prose,
- that note must not state guilt, motive, or outcome as fact.

Example acceptable note:
- `Episode injection: broken promise pressure introduced. Evening shortage window opened. Nikita returned without the promised filters.`

## 10. Run DM rule

Run DM must treat the episode as:
- a new pressure frame,
- new available cues,
- maybe new uncertainty,
- maybe new pending commitments,
- maybe new resource changes,
- a need to concretize the pressure from the current runtime state rather than from the template's imagined opening.

Before applying an episode mid-run, Run DM should perform a compatibility check:
1. read the current `campaign/run/world_state.json`
2. verify current zones, scarce resources, unresolved promises, and active pressures
3. reject any direct patch that would overwrite live continuity without explicit authorization
4. realize the episode through the lightest valid delta that still exposes the intended pressure

Run DM may concretize an episode at the next meaningful tick, for example by:
- choosing which scarce resource becomes socially salient now,
- choosing which character is in position to make or receive a commitment,
- surfacing a newly noticed shortage, discrepancy, message, or outside event,
- converting a template pressure into a live offer, request, discovery, or coordination need.

Run DM must **not** treat the episode as:
- a required dramatic arc,
- a forced conflict,
- proof that someone is guilty,
- a permission slip to skip appraisal,
- permission to rewrite positions, commitments, or actions retroactively so the template can start cleanly.

## 11. Completion rule

An episode ends when one of these becomes true:
- declared completion signals are met,
- the situation has naturally collapsed into a stable aftermath,
- the tick budget is exhausted and Lab DM intentionally parks it,
- the situation becomes impossible because world state has changed too much.

When an episode ends:
1. update `run/episode_state.json`
2. keep all resulting world / cast changes
3. inject the next episode delta only when intentionally advancing

## 12. Review use

During review, check not only whether something interesting happened, but whether:
- the episode exposed the intended pressure,
- different characters reacted differently,
- memory / relation drift accumulated,
- ambiguity remained ambiguity,
- state carried over honestly into later episodes.

## 13. Safety

Forbidden:
- resetting characters between episodes without explicit declared reason,
- writing episode outcomes by hand,
- converting template suggestions into certainty,
- injecting private facts that bypass world discovery,
- making every episode social-only or survival-only.

A good campaign should mix:
- trust / expectation episodes,
- fairness / burden episodes,
- ambiguity / suspicion episodes,
- survival / scarcity episodes,
- outside-event episodes,
- repair / recovery episodes.
