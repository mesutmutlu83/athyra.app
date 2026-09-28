#!/usr/bin/env python3
"""Validate the shared application-document scaffold and source audit."""

import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / ".agents/departments/engineering/templates/project-docs/manifest.json"
VALID_STATUS = {
    "covered", "partial", "missing", "conflict", "decision_needed",
    "no_source", "not_applicable",
}


def main() -> int:
    errors: list[str] = []
    try:
        manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"INVALID_DOC_MANIFEST: {exc}", file=sys.stderr)
        return 1

    documents = manifest.get("documents")
    if not isinstance(documents, list) or not documents:
        print("INVALID_DOC_MANIFEST: documents must be a nonempty array", file=sys.stderr)
        return 1
    required: set[str] = set()
    for entry in documents:
        if not isinstance(entry, dict):
            errors.append("invalid document entry")
            continue
        path = entry.get("path")
        if not isinstance(path, str) or not path.startswith("docs/") or Path(path).suffix != ".md" or ".." in Path(path).parts:
            errors.append(f"unsafe document path: {path}")
            continue
        if path in required:
            errors.append(f"duplicate document path: {path}")
        required.add(path)
        document = ROOT / path
        if not document.is_file():
            errors.append(f"missing scaffold document: {path}")
        elif path == manifest.get("source_document"):
            if document.read_text(encoding="utf-8").startswith("# Project brief\n\n> Status: needs_review."):
                errors.append(f"unfinished scaffold document: {path}")
        elif not path.endswith("/README.md") and "-template/" not in path and not path.endswith("ADR-000-template.md"):
            if "> Status: needs_review" in document.read_text(encoding="utf-8"):
                errors.append(f"unfinished scaffold document: {path}")
        if not entry.get("owner") or not entry.get("questions"):
            errors.append(f"missing owner or audit questions: {path}")

    for directory in manifest.get("directories", []):
        if not isinstance(directory, str) or not directory.startswith("docs/") or ".." in Path(directory).parts:
            errors.append(f"unsafe directory: {directory}")
        elif not (ROOT / directory).is_dir():
            errors.append(f"missing scaffold directory: {directory}")

    report_path = manifest.get("coverage_report")
    if not isinstance(report_path, str) or report_path != "docs/01-product/document-coverage.md":
        errors.append("invalid coverage report path")
    else:
        report = ROOT / report_path
        if not report.is_file():
            errors.append(f"missing coverage report: {report_path}")
        else:
            all_app_docs = {
                path.relative_to(ROOT).as_posix()
                for path in (ROOT / "docs").rglob("*.md")
                if path != report
            }
            seen: set[str] = set()
            report_lines = report.read_text(encoding="utf-8").splitlines()
            row_numbers = [i for i, line in enumerate(report_lines) if line.startswith("| `docs/")]
            if row_numbers and any(
                not report_lines[i].startswith("|")
                for i in range(row_numbers[0], row_numbers[-1] + 1)
            ):
                errors.append("coverage table rows are separated by non-table lines")
            for line in report_lines:
                if not line.startswith("| `docs/"):
                    continue
                cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
                if len(cells) != 6:
                    errors.append(f"coverage row must have six columns: {line[:100]}")
                    continue
                path = cells[0].strip("`")
                if path in seen:
                    errors.append(f"duplicate coverage row: {path}")
                seen.add(path)
                if cells[3] not in VALID_STATUS:
                    errors.append(f"unreviewed or invalid coverage status: {path}: {cells[3]}")
                if not cells[1] or not cells[2] or not cells[4] or not cells[5]:
                    errors.append(f"incomplete coverage row: {path}")
                if any("needs_review" in cell for cell in cells[1:]):
                    errors.append(f"unfinished coverage placeholder: {path}")
            for path in sorted(all_app_docs - seen):
                errors.append(f"missing coverage row: {path}")
            for path in sorted(seen - all_app_docs):
                errors.append(f"orphan coverage row: {path}")

    if errors:
        for error in errors:
            print(f"DOC_SCAFFOLD_ERROR: {error}", file=sys.stderr)
        return 1
    print(f"DOC_SCAFFOLD_OK: {len(required)} scaffold documents, {len(seen)} reviewed coverage rows")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
