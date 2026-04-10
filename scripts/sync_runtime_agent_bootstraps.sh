#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_AGENTS_DIR="$REPO_ROOT/runtime_agents"
STATE_ROOT="/home/sf/.openclaw"

copy_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

copy_file "$RUNTIME_AGENTS_DIR/rundm/AGENTS.md" "$STATE_ROOT/workspace-rundm/AGENTS.md"
copy_file "$RUNTIME_AGENTS_DIR/rundm/SOUL.md" "$STATE_ROOT/workspace-rundm/SOUL.md"
copy_file "$REPO_ROOT/RUN_DM_INIT_TEMPLATE.md" "$STATE_ROOT/workspace-rundm/RUN_DM_INIT_TEMPLATE.md"
copy_file "$REPO_ROOT/PLAYER_AGENT_INIT_TEMPLATE.md" "$STATE_ROOT/workspace-rundm/PLAYER_AGENT_INIT_TEMPLATE.md"

for i in 01 02 03 04 05 06; do
  copy_file "$RUNTIME_AGENTS_DIR/runplayer/AGENTS.md" "$STATE_ROOT/workspace-runplayer${i}/AGENTS.md"
  copy_file "$RUNTIME_AGENTS_DIR/runplayer/SOUL.md" "$STATE_ROOT/workspace-runplayer${i}/SOUL.md"
done

echo "Synced runtime agent bootstraps from repo to live workspaces."
