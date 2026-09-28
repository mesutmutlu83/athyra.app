#!/usr/bin/env python3
"""Check local Markdown links in application or agent documentation."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent.parent
ALLOWED = {"docs", ".agents/departments"}
LINK = re.compile(r"(?<!!)\[[^]]+\]\(([^)]+)\)")

scopes = sys.argv[1:] or sorted(ALLOWED)
if any(scope not in ALLOWED for scope in scopes):
    raise SystemExit("Usage: validate-document-links.py [docs] [.agents/departments]")

errors: list[str] = []
checked = 0
for scope in scopes:
    for guide in (ROOT / scope).rglob("*.md"):
        if guide.is_symlink():
            continue
        for target in LINK.findall(guide.read_text(encoding="utf-8")):
            if target.startswith(("http://", "https://", "mailto:", "data:", "#")):
                continue
            local = target.split("#", 1)[0]
            if not local:
                continue
            checked += 1
            resolved = (guide.parent / local).resolve()
            if not resolved.is_relative_to(ROOT) or not resolved.exists():
                errors.append(f"{guide.relative_to(ROOT)}: broken or escaping link {target}")

if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)
print(f"DOC_LINKS_OK: {checked} local links")
