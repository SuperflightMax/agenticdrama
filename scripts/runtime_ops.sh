#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAMPAIGNS="$ROOT/campaigns"
ACTIVE="$ROOT/campaign"
RUN_FILES=(
  "story_log.md"
  "turn_log.jsonl"
  "tick_snapshots.jsonl"
  "world_state.json"
  "metadata.json"
  "review_summary.md"
  "episode_state.json"
)
RUNTIME_SOURCE_FILE=".runtime_source_campaign"

usage() {
  cat <<'USAGE'
Usage:
  scripts/runtime_ops.sh create-campaign <name> [--from <source>] [--force]
  scripts/runtime_ops.sh activate <campaign_name>
  scripts/runtime_ops.sh snapshot <campaign_name>
  scripts/runtime_ops.sh new-run --run-id <run_id>
  scripts/runtime_ops.sh restore-run <archive_name>
USAGE
}

ensure_dir() {
  mkdir -p "$1"
}

copytree_replace() {
  local src="$1"
  local dst="$2"
  rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
}

strip_campaign_prefix() {
  local raw="$1"
  raw="${raw#campaigns/}"
  raw="${raw#./campaigns/}"
  raw="${raw%/}"
  printf '%s\n' "$raw"
}

read_json_string_field() {
  local file="$1"
  local field="$2"
  [ -f "$file" ] || return 1
  sed -n "s/.*\"$field\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file" | head -n 1
}

current_runtime_source() {
  if [ -f "$ACTIVE/$RUNTIME_SOURCE_FILE" ]; then
    cat "$ACTIVE/$RUNTIME_SOURCE_FILE"
    return 0
  fi

  local meta="$ACTIVE/run/metadata.json"
  if [ -f "$meta" ]; then
    local source
    source="$(read_json_string_field "$meta" "source_campaign" || true)"
    if [ -n "$source" ]; then
      strip_campaign_prefix "$source"
      return 0
    fi
    source="$(read_json_string_field "$meta" "campaign" || true)"
    if [ -n "$source" ]; then
      strip_campaign_prefix "$source"
      return 0
    fi
    source="$(read_json_string_field "$meta" "campaign_id" || true)"
    if [ -n "$source" ] && [ -d "$CAMPAIGNS/$source" ]; then
      strip_campaign_prefix "$source"
      return 0
    fi
  fi

  return 1
}

has_meaningful_run_content() {
  local run_dir="$1"
  [ -d "$run_dir" ] || return 1
  local file size
  for file in "${RUN_FILES[@]}"; do
    if [ -f "$run_dir/$file" ]; then
      size=$(wc -c < "$run_dir/$file")
      if [ "$size" -gt 0 ]; then
        case "$file" in
          metadata.json)
            if grep -q '"run_id"[[:space:]]*:[[:space:]]*null' "$run_dir/$file" 2>/dev/null; then
              continue
            fi
            ;;
          world_state.json)
            if grep -q '^[[:space:]]*{}[[:space:]]*$' "$run_dir/$file" 2>/dev/null; then
              continue
            fi
            ;;
        esac
        return 0
      fi
    fi
  done
  return 1
}

archive_active_run() {
  local active_campaign="$1"
  local archive_name="${2:-}"
  local run_dir="$active_campaign/run"
  has_meaningful_run_content "$run_dir" || return 1

  local meta="$run_dir/metadata.json"
  local run_id ts name archive_dir
  run_id="$(read_json_string_field "$meta" "run_id" || true)"
  [ -n "$run_id" ] || run_id="run"
  ts="$(date +%Y-%m-%d-%H%M%S)"
  name="${archive_name:-$ts-$run_id}"
  archive_dir="$active_campaign/run_archive/$name"
  ensure_dir "$active_campaign/run_archive"
  copytree_replace "$run_dir" "$archive_dir"
  printf '%s\n' "$archive_dir"
}

sync_run_back_to_campaign_root() {
  local campaign_dir="$1"
  local run_world="$campaign_dir/run/world_state.json"
  [ -f "$run_world" ] || return 0
  if grep -q '^[[:space:]]*{}[[:space:]]*$' "$run_world" 2>/dev/null; then
    return 0
  fi
  cp -f "$run_world" "$campaign_dir/world_state.json"
}

write_runtime_source_marker() {
  local campaign_dir="$1"
  local source_name="$2"
  printf '%s\n' "$source_name" > "$campaign_dir/$RUNTIME_SOURCE_FILE"
}

reset_run_dir() {
  local run_dir="$1"
  ensure_dir "$run_dir"
  : > "$run_dir/story_log.md"
  : > "$run_dir/turn_log.jsonl"
  : > "$run_dir/tick_snapshots.jsonl"
  : > "$run_dir/review_summary.md"
  printf '{}\n' > "$run_dir/world_state.json"
  cat > "$run_dir/metadata.json" <<'JSON'
{
  "run_id": "unset",
  "status": "ready_not_started",
  "valid_for_model_testing": "not_run_yet",
  "active_cast": [],
  "source_campaign": null,
  "model_layers": {},
  "notes": [],
  "unresolved_issues": []
}
JSON
  cat > "$run_dir/episode_state.json" <<'JSON'
{
  "active_episode_id": null,
  "active_episode_index": null,
  "status": "no_episode_selected",
  "completed_episode_ids": [],
  "pending_episode_ids": [],
  "last_injection_notes": []
}
JSON
}

cmd_create_campaign() {
  local name="${1:-}"
  [ -n "$name" ] || { usage; exit 1; }
  shift || true

  local source="TEMPLATE"
  local force=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --from)
        shift
        source="${1:-}"
        [ -n "$source" ] || { echo "Missing value for --from" >&2; exit 1; }
        ;;
      --force)
        force=1
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift || true
  done

  local src="$CAMPAIGNS/$source"
  local dst="$CAMPAIGNS/$name"
  [ -d "$src" ] || { echo "Source campaign not found: $src" >&2; exit 1; }
  if [ -e "$dst" ] && [ "$force" -ne 1 ]; then
    echo "Destination exists: $dst. Use --force to overwrite." >&2
    exit 1
  fi
  copytree_replace "$src" "$dst"
  rm -rf "$dst/runs"
  write_runtime_source_marker "$dst" "$name"
  echo "Created campaign: $dst"
}

save_active_runtime_back_to_storage() {
  [ -d "$ACTIVE" ] || return 0

  local current_source
  current_source="$(current_runtime_source || true)"
  [ -n "$current_source" ] || return 0

  local dst="$CAMPAIGNS/$current_source"
  [ -d "$dst" ] || return 0

  sync_run_back_to_campaign_root "$ACTIVE"
  copytree_replace "$ACTIVE" "$dst"
  write_runtime_source_marker "$dst" "$current_source"
  echo "Saved active runtime back to storage: $dst"
}

cmd_activate() {
  local name="${1:-}"
  [ -n "$name" ] || { usage; exit 1; }
  local src="$CAMPAIGNS/$name"
  [ -d "$src" ] || { echo "Campaign not found: $src" >&2; exit 1; }

  if [ -d "$ACTIVE" ]; then
    local archived=""
    archived="$(archive_active_run "$ACTIVE" || true)"
    sync_run_back_to_campaign_root "$ACTIVE"
    save_active_runtime_back_to_storage
    if [ -n "$archived" ]; then
      echo "Archived previous active run to: $archived"
    fi
  fi

  copytree_replace "$src" "$ACTIVE"
  rm -rf "$ACTIVE/runs"
  write_runtime_source_marker "$ACTIVE" "$name"
  echo "Activated campaign: $src -> $ACTIVE"
}

cmd_snapshot() {
  local name="${1:-}"
  [ -n "$name" ] || { usage; exit 1; }
  [ -d "$ACTIVE" ] || { echo "Active campaign/ does not exist" >&2; exit 1; }
  local dst="$CAMPAIGNS/$name"
  sync_run_back_to_campaign_root "$ACTIVE"
  copytree_replace "$ACTIVE" "$dst"
  rm -rf "$dst/runs"
  write_runtime_source_marker "$dst" "$name"
  echo "Snapshot saved: $ACTIVE -> $dst"
}

cmd_new_run() {
  [ -d "$ACTIVE" ] || { echo "Active campaign/ does not exist" >&2; exit 1; }
  local run_id=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --run-id)
        shift
        run_id="${1:-}"
        [ -n "$run_id" ] || { echo "Missing value for --run-id" >&2; exit 1; }
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift || true
  done
  [ -n "$run_id" ] || { echo "--run-id is required" >&2; exit 1; }

  local archived=""
  archived="$(archive_active_run "$ACTIVE" || true)"
  local run_dir="$ACTIVE/run"
  reset_run_dir "$run_dir"
  if [ -f "$ACTIVE/world_state.json" ]; then
    cp -f "$ACTIVE/world_state.json" "$run_dir/world_state.json"
  fi

  local cast_ids_json='[]'
  if [ -d "$ACTIVE/cast" ]; then
    cast_ids_json="$({ find "$ACTIVE/cast" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | sed 's/.*/"&"/' | paste -sd, -; } | sed 's/^/[/' | sed 's/$/]/')"
    [ "$cast_ids_json" != "[]" ] || cast_ids_json='[]'
  fi

  local source_name
  source_name="$(current_runtime_source || basename "$ACTIVE")"

  local pending_episode_ids='[]'
  local episode_state_status='no_episode_selected'
  if [ -f "$ACTIVE/episode_plan.json" ]; then
    pending_episode_ids="$({ awk -F'"' '/"episode_id"[[:space:]]*:/ {print "\"" $4 "\""}' "$ACTIVE/episode_plan.json" | paste -sd, -; } | sed 's/^/[/' | sed 's/$/]/')"
    [ "$pending_episode_ids" != "[]" ] || pending_episode_ids='[]'
    if [ "$pending_episode_ids" != '[]' ]; then
      episode_state_status='ready_for_first_episode'
    fi
  fi

  cat > "$run_dir/metadata.json" <<JSON
{
  "run_id": "$run_id",
  "status": "ready_not_started",
  "valid_for_model_testing": "not_run_yet",
  "active_cast": $cast_ids_json,
  "source_campaign": "$source_name",
  "episode_queue_file": "episode_plan.json",
  "episode_state_file": "run/episode_state.json",
  "model_layers": {
    "world_cues": {"used": false, "updated": false},
    "attention": {"used": false, "updated": false},
    "appraisal": {"used": false, "updated": false},
    "state_update": {"used": false, "updated": false},
    "memory_activation": {"used": false, "updated": false},
    "relationship_dynamics": {"used": false, "updated": false},
    "action_pulls": {"used": false, "updated": false}
  },
  "notes": ["Fresh run scaffolded by scripts/runtime_ops.sh"],
  "unresolved_issues": []
}
JSON

  cat > "$run_dir/episode_state.json" <<JSON
{
  "active_episode_id": null,
  "active_episode_index": null,
  "status": "$episode_state_status",
  "completed_episode_ids": [],
  "pending_episode_ids": $pending_episode_ids,
  "last_injection_notes": [
    "Fresh run scaffolded by scripts/runtime_ops.sh",
    "Inject the first enabled episode from episode_plan.json before first serious progression."
  ]
}
JSON

  if [ -n "$archived" ]; then
    echo "Archived previous run to: $archived"
  fi
  echo "Initialized fresh run: $run_dir"
}

cmd_restore_run() {
  local archive_name="${1:-}"
  [ -n "$archive_name" ] || { usage; exit 1; }
  local src="$ACTIVE/run_archive/$archive_name"
  [ -d "$src" ] || { echo "Archived run not found: $src" >&2; exit 1; }
  local dst="$ACTIVE/run"
  copytree_replace "$src" "$dst"
  echo "Restored archived run: $src -> $dst"
}

main() {
  local cmd="${1:-}"
  [ -n "$cmd" ] || { usage; exit 1; }
  shift || true

  case "$cmd" in
    create-campaign) cmd_create_campaign "$@" ;;
    activate) cmd_activate "$@" ;;
    snapshot) cmd_snapshot "$@" ;;
    new-run) cmd_new_run "$@" ;;
    restore-run) cmd_restore_run "$@" ;;
    -h|--help|help) usage ;;
    *)
      echo "Unknown command: $cmd" >&2
      usage
      exit 1
      ;;
  esac
}

main "$@"
