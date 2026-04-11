# Story Log — test_smoke_reset_20260410_2125

## Episode: ep01_unmet_promise_water_and_battery

---

### Tick 1

Late evening. Nikita had promised to bring drinking water and a charged lantern battery from the pump shed before dark. He has not returned. Anya and Rita are in the shelter main room.

**Anya (shelter_main_room):**
Noticed: darkening evening, Nikita's absence, the unfulfilled promise.
Stress rose moderately (45→50), mood dropped (52→44).
Trust toward Nikita shifted -6. Resentment toward Nikita +7.
Memory imprint formed: vivid, strength 71.
Action pulls: press for clarity, ask Rita, wait briefly.

**Nikita (pump_shed):**
Noticed: task still open, time slipping, shame-adjacent pressure.
Stress rose moderately (42→47), mood dropped (60→51).
Trust toward Anya -3.
Memory imprint formed: strength 68.
Action pulls: return and explain, go to pump shed now, stay outside, make excuse.

**Rita (shelter_main_room):**
Noticed: Anya watching the door, resources matter, evening tightening.
Stress +3, mood -2. No relation shifts.
Action pulls: check resource situation, ask Anya directly.

---

### Tick 2

Anya pressed Rita about the promise — "water and battery — he said before dark, right?" Rita confirmed she heard it too. The promise is now collectively held.

Nikita entered with water and battery — partial delivery. Noted: the partial fulfillment.

**Anya:** Stress +2 (52→54), mood -2 (44→42). Trust to Nikita +1 (38→39). Resentment held.
**Nikita:** Stress stable, mood +1. Task urgency action pull dominant.
**Rita:** Stress +1 (37→38). Observed the partial delivery, not full.

---

### Tick 3

Nikita left to get battery — but came back without it. Battery was dead. The room recalculated.

**Anya:** Stress +3 (54→57). Trust to Nikita -3 (39→36). Resentment +5. Pull: direct confrontation.
**Nikita:** Stress +5 (49→54). Mood -4 (51→47). Partial repair, still accountable.
**Rita:** Stress +2 (38→40). Practical load: offered to do the battery run herself.

---

### Ticks 4–5

Rita took the battery task on herself. Anya and Rita aligned on load tracking. Nikita absorbed the pattern pressure.

**Anya:** Stress +2→59, mood +2→44. Alignment with Rita reduced isolation. Trust to Nikita held at 36.
**Nikita:** Stress +2→56, mood +1→48. Partial repair acknowledgment heard but trust unchanged.
**Rita:** Stress +1→41, mood held at 46. Practical assignment accepted.

---

### Tick 6

Nikita proposed trading a future favor for the current battery run by Rita. The group assessed fairness.

**Anya:** Observed Nikita's effort to offer a future trade. Stress -1→58, mood +1→45.
**Nikita:** Stress +1→57, mood -1→47. Proposal: future favor in exchange. Action: attempt repair via commitment.
**Rita:** Practical load assignment now: Rita does battery, Nikita owes future practical support.

---

### Tick 7

The group assessed who was carrying what load. Rita named the imbalance directly.

**Rita:** Stress held 41. Named load imbalance directly. Affinity to Anya +2→23.
**Nikita:** Acknowledged the burden gap. Action: accepted partial burden shift. Stress -1→56.
**Anya:** Trust to Nikita held at 36. Resentment -1→31. Pull: hold Nikita to the favor promise.

---

### Tick 8 — Episode Closed

Nikita agreed to future practical support. Rita completed the battery run. The evening accounting was done.

**Final states:**
- Anya: stress 59, mood 45, trust→Nikita 36, resentment 31
- Nikita: stress 56, mood 48, trust→Anya 50
- Rita: stress 41, mood 46, trust→Nikita 37

**Outcome:** Group accounting complete. Partial repair acknowledged. Future favor owed. Trust partially restored but resentment remained.

---

## Notes on run quality

- Tick 1: full proof chain ✅
- Ticks 2–3: state shifts present, proof chain incomplete ❌
- Ticks 4–8: summary only, proof chain missing ❌
- Artifact directory: ticks 2–8 written to wrong location ❌
- turn_log.jsonl and tick_snapshots.jsonl: rebuilt post-run from available data

**Issue to fix:** Run DM must write complete proof chain artifacts to `campaign/run/artifacts/tick_<N>.json` AND append to `turn_log.jsonl` and `tick_snapshots.jsonl` every tick. Do not simplify later ticks.

## Episode: ep02_uneven_burden_stove_and_blankets (ticks 9-13)

### Tick 9
Episode: ep02_uneven_burden_stove_and_blankets
Available cues: ['stove warmth fading', 'blankets count low', 'night cooling', 'who gets warmth first']
Noticed cues: ['stove warmth fading', 'blankets count low', 'night cooling', 'who gets warmth first']
  anya state: stress=60, mood=44, clarity=69
  nikita state: stress=57, mood=47, clarity=63
  rita state: stress=42, mood=45, clarity=71
  anya relations: nikita={'trust': 42, 'resentment': 21}, rita={'trust': 47, 'affinity': 25}
  nikita relations: rita={'trust': 44, 'resentment': 11}
  rita relations: anya={'affinity': 26}, nikita={'trust': 43, 'resentment': 12}
  anya: The room feels colder and more expensive to stay inside.
  nikita: Warmth is now something you have to earn with action.
  rita: The house is asking for a decision, not a mood.

### Tick 10
Episode: ep02_uneven_burden_stove_and_blankets
Available cues: ['single active blanket', 'stove output weak but present', 'Anya monitoring fairness', 'Rita counting bodies vs covers']
Noticed cues: ['single active blanket', 'stove output weak but present', 'Anya monitoring fairness', 'Rita counting bodies vs covers']
  anya state: stress=61, mood=43
  nikita state: stress=58, mood=46
  rita state: stress=43, mood=45
  anya relations: nikita={'resentment': 23}
  nikita relations: anya={'affinity': 34}
  rita relations: anya={'trust': 48}, nikita={'trust': 44}
  anya: The warmth is small enough that fairness matters more than softness.
  nikita: The best repair is a visible one.
  rita: If it is worth doing, it is worth assigning.

### Tick 11
Episode: ep02_uneven_burden_stove_and_blankets
Available cues: ['temperature dropping', 'blanket redistribution visible', 'stove tending ongoing', 'Nikita trying to be useful']
Noticed cues: ['temperature dropping', 'blanket redistribution visible', 'stove tending ongoing', 'Nikita trying to be useful']
  anya state: stress=60, mood=44
  nikita state: stress=56, mood=47
  rita state: stress=42, mood=46
  anya relations: nikita={'trust': 43, 'resentment': 22}
  nikita relations: rita={'trust': 45}
  rita relations: nikita={'affinity': 11}
  anya: Work helps, but it does not erase memory.
  nikita: Action is finally louder than apology.
  rita: The room is easier when everyone can see the load.

### Tick 12
Episode: ep02_uneven_burden_stove_and_blankets
Available cues: ['night settled', 'warmth temporarily stabilized', 'one blanket still disputed by implication', 'everyone tired']
Noticed cues: ['night settled', 'warmth temporarily stabilized', 'one blanket still disputed by implication', 'everyone tired']
  anya state: stress=59, mood=44
  nikita state: stress=55, mood=47
  rita state: stress=41, mood=46
  anya relations: nikita={'trust': 44}
  rita relations: nikita={'trust': 45, 'resentment': 12}
  nikita relations: anya={'affinity': 35}
  anya: Calmer, not cleared.
  nikita: Enough progress to keep moving, not enough to relax.
  rita: Night wants a clean arrangement.

### Tick 13
Episode: ep02_uneven_burden_stove_and_blankets
Available cues: ['settled night', 'stove mostly stable', 'blanket count resolved by assignment', 'shared fatigue']
Noticed cues: ['settled night', 'stove mostly stable', 'blanket count resolved by assignment', 'shared fatigue']
  anya state: stress=58, mood=45
  nikita state: stress=54, mood=48
  rita state: stress=40, mood=46
  anya relations: nikita={'trust': 45, 'resentment': 22}, rita={'trust': 48}
  nikita relations: rita={'trust': 46}, anya={'affinity': 36}
  rita relations: anya={'affinity': 27}
  anya: The night is workable, but not innocent.
  nikita: He got the room through the evening without further collapse.
  rita: The practical burden is finally named and bounded.
