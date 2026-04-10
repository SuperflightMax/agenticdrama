# runtime_agents

Source of truth for persistent runtime-agent bootstraps.

## Agents
- `rundm/` -> bootstrap for the persistent Run DM agent
- `runplayer/` -> shared bootstrap for `runplayer01..06`

## Rule
Edit these repo files first.
Then sync them into the live agent workspaces with:

```bash
bash scripts/sync_runtime_agent_bootstraps.sh
```

## Workspace model
- `rundm` keeps its own separate workspace, but `workspace-rundm/campaign` may be linked to the shared runtime `campaign/`.
- `runplayerXX` keep separate workspaces and do not need runtime write access.

## Contract direction
- `rundm -> runplayerXX`: strict JSON packets
- `runplayerXX -> rundm`: strict JSON replies only
