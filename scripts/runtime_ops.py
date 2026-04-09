#!/usr/bin/env python3
from __future__ import annotations
import argparse, datetime, json, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CAMPAIGNS = ROOT / "campaigns"
ACTIVE = ROOT / "campaign"

RUN_FILES = [
    "story_log.md",
    "turn_log.jsonl",
    "tick_snapshots.jsonl",
    "world_state.json",
    "metadata.json",
    "review_summary.md",
]

def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)

def reset_run_dir(run_dir: Path) -> None:
    ensure_dir(run_dir)
    for name in RUN_FILES:
        p = run_dir / name
        if name.endswith(".json"):
            if name == "metadata.json":
                p.write_text(json.dumps({
                    "run_id": "unset",
                    "status": "ready_not_started",
                    "valid_for_model_testing": "not_run_yet",
                    "active_cast": [],
                    "source_campaign": None,
                    "model_layers": {},
                    "notes": [],
                    "unresolved_issues": []
                }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            else:
                p.write_text("{}\n", encoding="utf-8")
        else:
            p.write_text("", encoding="utf-8")

def copytree_replace(src: Path, dst: Path) -> None:
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)

def archive_active_run(active_campaign: Path, archive_name: str | None = None) -> Path | None:
    run_dir = active_campaign / "run"
    if not run_dir.exists():
        return None
    has_content = any((run_dir / f).exists() and (run_dir / f).stat().st_size > 0 for f in RUN_FILES)
    if not has_content:
        return None
    metadata = {}
    meta_path = run_dir / "metadata.json"
    if meta_path.exists():
        try:
            metadata = json.loads(meta_path.read_text(encoding="utf-8"))
        except Exception:
            metadata = {}
    run_id = metadata.get("run_id") or "run"
    ts = datetime.datetime.now().strftime("%Y-%m-%d-%H%M%S")
    name = archive_name or f"{ts}-{run_id}"
    archive_dir = active_campaign / "run_archive" / name
    ensure_dir(archive_dir.parent)
    copytree_replace(run_dir, archive_dir)
    return archive_dir

def cmd_create_campaign(args):
    src = CAMPAIGNS / (args.source or "TEMPLATE")
    dst = CAMPAIGNS / args.name
    if not src.exists():
        raise SystemExit(f"Source campaign not found: {src}")
    if dst.exists() and not args.force:
        raise SystemExit(f"Destination exists: {dst}. Use --force to overwrite.")
    copytree_replace(src, dst)
    print(f"Created campaign: {dst}")

def cmd_activate(args):
    src = CAMPAIGNS / args.name
    if not src.exists():
        raise SystemExit(f"Campaign not found: {src}")
    copytree_replace(src, ACTIVE)
    print(f"Activated campaign: {src} -> {ACTIVE}")

def cmd_snapshot(args):
    src = ACTIVE
    dst = CAMPAIGNS / args.name
    if not src.exists():
        raise SystemExit("Active campaign/ does not exist")
    ensure_dir(dst.parent)
    copytree_replace(src, dst)
    print(f"Snapshot saved: {src} -> {dst}")

def cmd_new_run(args):
    if not ACTIVE.exists():
        raise SystemExit("Active campaign/ does not exist")
    archived = archive_active_run(ACTIVE)
    run_dir = ACTIVE / "run"
    reset_run_dir(run_dir)
    baseline = ACTIVE / "world_state.json"
    if baseline.exists():
        shutil.copy2(baseline, run_dir / "world_state.json")
    cast_ids = []
    cast_dir = ACTIVE / "cast"
    if cast_dir.exists():
        cast_ids = sorted([p.name for p in cast_dir.iterdir() if p.is_dir()])
    metadata = {
        "run_id": args.run_id,
        "status": "ready_not_started",
        "valid_for_model_testing": "not_run_yet",
        "active_cast": cast_ids,
        "source_campaign": ACTIVE.name,
        "model_layers": {
            "world_cues": {"used": False, "updated": False},
            "attention": {"used": False, "updated": False},
            "appraisal": {"used": False, "updated": False},
            "state_update": {"used": False, "updated": False},
            "memory_activation": {"used": False, "updated": False},
            "relationship_dynamics": {"used": False, "updated": False},
            "action_pulls": {"used": False, "updated": False}
        },
        "notes": ["Fresh run scaffolded by runtime_ops.py"],
        "unresolved_issues": []
    }
    (run_dir / "metadata.json").write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if archived:
        print(f"Archived previous run to: {archived}")
    print(f"Initialized fresh run: {run_dir}")

def cmd_restore_run(args):
    src = ACTIVE / "run_archive" / args.archive_name
    if not src.exists():
        raise SystemExit(f"Archived run not found: {src}")
    dst = ACTIVE / "run"
    copytree_replace(src, dst)
    print(f"Restored archived run: {src} -> {dst}")

def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("create-campaign")
    p.add_argument("name")
    p.add_argument("--from", dest="source")
    p.add_argument("--force", action="store_true")
    p.set_defaults(func=cmd_create_campaign)

    p = sub.add_parser("activate")
    p.add_argument("name")
    p.set_defaults(func=cmd_activate)

    p = sub.add_parser("snapshot")
    p.add_argument("name")
    p.set_defaults(func=cmd_snapshot)

    p = sub.add_parser("new-run")
    p.add_argument("--run-id", required=True)
    p.set_defaults(func=cmd_new_run)

    p = sub.add_parser("restore-run")
    p.add_argument("archive_name")
    p.set_defaults(func=cmd_restore_run)

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    main()
