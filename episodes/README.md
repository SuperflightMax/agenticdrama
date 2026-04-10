# episodes/README.md

`episodes/` is the global reusable library of episode templates.

Use it for situation shapes such as:
- broken / unmet promise,
- uneven burden,
- missing shared resource,
- outside emergency signal,
- repair attempt,
- scarcity,
- suspicion,
- fairness pressure.

Lab DM should:
- choose templates from this library when creating a campaign,
- concretize selected templates for the current world and cast,
- write campaign-specific instances into `campaign/episode_plan.json`,
- add newly discovered reusable templates back into this library.

Campaigns should store concrete episode instances in the plan, not duplicate the template library inside the campaign.
If an older campaign still has `campaign/episode_templates/`, treat it as legacy scratch material rather than canonical truth.

Do not treat templates here as scripted outcomes.
They are pressure shapes, not mandatory arcs.
