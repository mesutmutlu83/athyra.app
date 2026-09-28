#!/usr/bin/env python3
"""Create the canonical application documentation scaffold without overwriting work."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
from pathlib import Path, PurePosixPath


REPO_ROOT = Path(__file__).resolve().parents[1]
TEMPLATE_ROOT = (
    REPO_ROOT / ".agents/departments/engineering/templates/project-docs"
)
MANIFEST_PATH = TEMPLATE_ROOT / "manifest.json"


def canonical_path(root: Path, raw: str) -> Path:
    relative = PurePosixPath(raw)
    if relative.is_absolute() or not relative.parts or ".." in relative.parts:
        raise ValueError(f"Unsafe manifest path: {raw}")
    destination = root.joinpath(*relative.parts)
    if not destination.resolve().is_relative_to(root):
        raise ValueError(f"Manifest path escapes project root: {raw}")
    return destination


def template_source(relative_path: str) -> Path | None:
    if relative_path == "docs/03-architecture/adrs/ADR-000-template.md":
        return TEMPLATE_ROOT / "ADR-000-template.md"
    prefix = "docs/features/FEAT-000-template/"
    if relative_path.startswith(prefix):
        return TEMPLATE_ROOT / "feature" / relative_path.removeprefix(prefix)
    return None


def make_index(entry: dict, entries: list[dict]) -> str:
    path = PurePosixPath(entry["path"])
    lines = [
        f"# {entry['title']}",
        "",
        "Application documentation index. Linked documents require review against the "
        "initial Markdown and repository evidence before their content is treated as current.",
        "",
    ]
    if path.as_posix() == "docs/README.md":
        selected = [
            item for item in entries
            if item["path"].endswith("/README.md")
            and item["path"].count("/") == 2
        ]
        selected.append(next(item for item in entries if item["path"] == "docs/features/README.md"))
    elif path.as_posix() == "docs/features/README.md":
        lines += [
            "Copy `FEAT-000-template/` to a stable feature ID for each meaningful "
            "product change, then fill it with verified scope and evidence.",
            "",
        ]
        selected = [
            item for item in entries
            if item["path"].startswith("docs/features/FEAT-000-template/")
        ]
    else:
        prefix = path.parent.as_posix() + "/"
        selected = [
            item for item in entries
            if item["path"].startswith(prefix)
            and item["path"] != path.as_posix()
            and (item["path"].count("/") == path.as_posix().count("/"))
        ]
    for item in selected:
        target = PurePosixPath(item["path"])
        relative = os.path.relpath(str(target), str(path.parent))
        lines.append(f"- [{item['title']}]({relative})")
    if path.as_posix() == "docs/01-product/README.md":
        lines.append("- [Document coverage](document-coverage.md)")
    if path.as_posix() == "docs/03-architecture/README.md":
        lines.append("- [Architecture decision template](adrs/ADR-000-template.md)")
    lines.append("")
    return "\n".join(lines)


def make_document(entry: dict) -> str:
    lines = [
        f"# {entry['title']}",
        "",
        "> Status: needs_review. Replace these prompts only after reviewing source and "
        "repository evidence. A blank answer is an unknown, not an accepted decision.",
        "",
        "## Evidence and current state",
        "",
        "- Initial Markdown evidence:",
        "- Repository evidence:",
        "- Last checked:",
        "",
        "## Questions to resolve",
        "",
    ]
    lines.extend(f"- {question}" for question in entry["questions"])
    lines += [
        "",
        "## Decisions and unknowns",
        "",
        "- Open information:",
        "- Owner or human decision:",
        "",
    ]
    return "\n".join(lines)


def escape_cell(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def make_coverage(entries: list[dict], source: Path | None) -> str:
    if source is None:
        source_description = "no_source: no initial Markdown was supplied to bootstrap."
        source_cell = "no_source; assess other evidence"
    else:
        source_description = (
            f"Initial Markdown supplied: `{source.name}`. Its content has not been "
            "semantically mapped to these documents yet."
        )
        source_cell = "needs_review against input Markdown"
    lines = [
        "# Application document coverage",
        "",
        source_description,
        "",
        "This register is an assessment queue, not a claim that information is missing. "
        "The responsible agent must review every static and pre-existing dynamic document "
        "against the input Markdown and "
        "repository, cite exact evidence, record unknowns and an owner, and report "
        "gaps or conflicts to the user. Use `covered`, `partial`, `missing`, "
        "`conflict`, `decision_needed`, `not_applicable` (with a reason), or "
        "`no_source` (when no initial Markdown was supplied). New rows begin as "
        "`needs_review`.",
        "",
        "| Document | Input MD evidence | Repository evidence | Status | Missing information | Owner/decision |",
        "|---|---|---|---|---|---|",
    ]
    for entry in entries:
        questions = "; ".join(entry["questions"])
        lines.append(
            f"| `{entry['path']}` | "
            f"{source_cell} | needs_review | needs_review | "
            f"To assess: {escape_cell(questions)} | "
            f"{escape_cell(entry['owner'])}; decision: needs_review |"
        )
    lines.append("")
    return "\n".join(lines)


def write_if_absent(destination: Path, content: str) -> bool:
    destination.parent.mkdir(parents=True, exist_ok=True)
    try:
        with destination.open("x", encoding="utf-8") as output:
            output.write(content)
    except FileExistsError:
        return False
    return True


def copy_if_absent(source: Path, destination: Path) -> bool:
    destination.parent.mkdir(parents=True, exist_ok=True)
    try:
        with destination.open("xb") as output, source.open("rb") as input_file:
            shutil.copyfileobj(input_file, output)
    except FileExistsError:
        return False
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True, help="Existing project root")
    parser.add_argument("--source", type=Path, help="Initial project Markdown")
    args = parser.parse_args()
    root = args.root.expanduser().resolve()
    if not root.is_dir():
        parser.error(f"Project root does not exist: {root}")
    source = args.source.expanduser().resolve() if args.source else None
    if source is not None and (not source.is_file() or source.suffix.lower() != ".md"):
        parser.error("--source must name an existing Markdown file")
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    entries = manifest["documents"]
    paths = [item["path"] for item in entries]
    if len(paths) != len(set(paths)):
        raise ValueError("Duplicate document path in manifest")
    for raw in paths + manifest["directories"] + [manifest["coverage_report"]]:
        canonical_path(root, raw)
    source_path = manifest["source_document"]
    if source_path not in paths:
        raise ValueError("Source document is missing from manifest")

    for raw in manifest["directories"]:
        canonical_path(root, raw).mkdir(parents=True, exist_ok=True)
    created = []
    preserved = []
    for entry in entries:
        raw = entry["path"]
        destination = canonical_path(root, raw)
        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.exists() or destination.is_symlink():
            preserved.append(raw)
            continue
        if raw == source_path and source is not None:
            (created if copy_if_absent(source, destination) else preserved).append(raw)
            continue
        template = template_source(raw)
        if template is not None:
            if not template.is_file():
                raise FileNotFoundError(f"Missing agent template: {template}")
            (created if copy_if_absent(template, destination) else preserved).append(raw)
            continue
        content = (
            make_index(entry, entries)
            if raw.endswith("/README.md")
            else make_document(entry)
        )
        (created if write_if_absent(destination, content) else preserved).append(raw)
    conflict_raw = None
    if source is not None and source_path in preserved:
        existing_source = canonical_path(root, source_path)
        if existing_source.read_bytes() != source.read_bytes():
            digest = hashlib.sha256(source.read_bytes()).hexdigest()[:16]
            conflict_raw = f"docs/01-product/source-candidates/input-{digest}.md"
            candidate = canonical_path(root, conflict_raw)
            (created if copy_if_absent(source, candidate) else preserved).append(conflict_raw)
            if candidate.read_bytes() != source.read_bytes():
                raise ValueError(f"Conflicting source snapshot differs: {candidate}")
    coverage_raw = manifest["coverage_report"]
    coverage = canonical_path(root, coverage_raw)
    known = set(paths)
    dynamic_entries = [
        {
            "path": path.relative_to(root).as_posix(),
            "owner": "Owning domain specialist",
            "questions": ["What source, decision, and implementation evidence supports this existing document?"],
        }
        for path in sorted((root / "docs").rglob("*.md"))
        if path.relative_to(root).as_posix() not in known | {coverage_raw}
    ]
    if write_if_absent(
        coverage,
        make_coverage(entries + dynamic_entries, source),
    ):
        created.append(coverage_raw)
    else:
        preserved.append(coverage_raw)
    # Git does not retain empty directories. Keep optional starter areas visible
    # until a real decision, source extension, screen, or runbook is added.
    for raw in manifest["directories"]:
        directory = canonical_path(root, raw)
        if not any(directory.iterdir()):
            marker = directory / ".gitkeep"
            marker.touch(exist_ok=True)
            created.append(marker.relative_to(root).as_posix())
    print(f"DOC_BOOTSTRAP_OK: {len(created)} created, {len(preserved)} preserved")
    if source is None:
        print("SOURCE_STATUS: no_source; no initial Markdown was supplied")
    elif source_path in created:
        print(f"SOURCE_STATUS: copied verbatim from {source}")
    else:
        print(f"SOURCE_STATUS: existing {source_path} preserved; supplied source was not copied")
        if conflict_raw is not None:
            print(
                "SOURCE_WARNING: supplied input differs byte-for-byte from the "
                f"existing project brief; unreviewed copy saved at {conflict_raw}; "
                "review both in the coverage assessment"
            )
    print(f"COVERAGE_REPORT: {coverage}")
    print("FOLLOW_UP: assess every coverage row against source and repository evidence")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
