#!/usr/bin/env python3
"""Validate physical department ownership and Codex discovery entrypoints."""

from collections import defaultdict
from pathlib import Path
import re
import sys
import tomllib


ROOT = Path(__file__).resolve().parent.parent
DEPARTMENTS = {
    "01-product": "product",
    "02-ux": "ux",
    "03-architecture": "architecture",
    "04-engineering": "engineering",
    "05-security": "security",
    "06-testing": "testing",
    "07-operations": "operations",
    "08-release": "release",
    "09-marketing": "marketing",
}
ALL_DEPARTMENTS = ("governance", *DEPARTMENTS.values())
LINK = re.compile(r"\[[^]]+\]\(([^)#]+)(?:#[^)]+)?\)")
SECTIONS = {"## Agent prompts": "agents", "## Skills": "skills"}
errors: list[str] = []
owners: dict[str, dict[Path, list[str]]] = {
    "agents": defaultdict(list),
    "skills": defaultdict(list),
}


def local_target(guide: Path, target: str) -> Path | None:
    if target.startswith(("https://", "http://", "mailto:")):
        return None
    if target.startswith("/"):
        errors.append(f"{guide.relative_to(ROOT)}: absolute link {target}")
        return None
    resolved = (guide.parent / target).resolve()
    if not resolved.is_relative_to(ROOT):
        errors.append(f"{guide.relative_to(ROOT)}: link escapes repo: {target}")
        return None
    if not resolved.exists():
        errors.append(f"{guide.relative_to(ROOT)}: broken link {target}")
    return resolved


def validate_links(guide: Path) -> None:
    for target in LINK.findall(guide.read_text(encoding="utf-8")):
        local_target(guide, target)


docs_home = (ROOT / "docs/README.md").read_text(encoding="utf-8")
for doc_folder, department in DEPARTMENTS.items():
    app_index = ROOT / "docs" / doc_folder / "README.md"
    if not app_index.is_file():
        errors.append(f"missing app document index: {app_index.relative_to(ROOT)}")
    else:
        validate_links(app_index)
        if "## Owned agent prompts" in app_index.read_text(encoding="utf-8") or "## Owned skills" in app_index.read_text(encoding="utf-8"):
            errors.append(f"agent ownership content remains in {app_index.relative_to(ROOT)}")
    if f"({doc_folder}/README.md)" not in docs_home:
        errors.append(f"docs/README.md does not link {doc_folder}/README.md")

if (ROOT / "docs/00-governance").exists():
    errors.append("agent governance remains under docs/00-governance")
for old in ("docs/04-engineering/coding-standards.md", "docs/06-testing/regression-strategy.md", "docs/07-operations/weekly-knowledge-scan.md"):
    if (ROOT / old).exists():
        errors.append(f"agent process remains under app docs: {old}")

for department in ALL_DEPARTMENTS:
    workspace = ROOT / ".agents/departments" / department / "README.md"
    for index in (workspace, workspace.parent / "OPERATING.md", workspace.parent / "knowledge/README.md"):
        if not index.is_file():
            errors.append(f"missing department index: {index.relative_to(ROOT)}")
    if not workspace.is_file():
        continue
    validate_links(workspace)
    body = workspace.read_text(encoding="utf-8")
    section = None
    found_sections: set[str] = set()
    for line in body.splitlines():
        if line.startswith("## "):
            section = SECTIONS.get(line)
            if section:
                found_sections.add(section)
        for target in LINK.findall(line):
            resolved = local_target(workspace, target)
            if resolved is None or section not in owners or not line.startswith("- "):
                continue
            if section == "agents":
                expected = ROOT / ".codex/agents" / department
                valid = resolved.suffix == ".toml" and resolved.parent == expected
            else:
                expected = ROOT / ".agents/departments" / department / "skills"
                valid = resolved.name == "SKILL.md" and resolved.parent.parent == expected
            if not valid:
                errors.append(f"{workspace.relative_to(ROOT)}: {section} owner link outside department: {target}")
                continue
            owners[section][resolved].append(department)
    if found_sections != set(SECTIONS.values()):
        errors.append(f"{workspace.relative_to(ROOT)}: both ownership headings are required")

actual_agents = set((ROOT / ".codex/agents").glob("*/*.toml"))
actual_skills = set((ROOT / ".agents/departments").glob("*/skills/*/SKILL.md"))
for kind, actual in (("agents", actual_agents), ("skills", actual_skills)):
    mapped = set(owners[kind])
    for missing in sorted(actual - mapped):
        errors.append(f"orphan {kind}: {missing.relative_to(ROOT)}")
    for unexpected in sorted(mapped - actual):
        errors.append(f"unexpected {kind} owner: {unexpected.relative_to(ROOT)}")
    for path, departments in owners[kind].items():
        if len(departments) != 1:
            errors.append(f"duplicate {kind} owner: {path.relative_to(ROOT)} in {departments}")

if list((ROOT / ".codex/agents").glob("*.toml")):
    errors.append("flat agent prompts remain under .codex/agents")

config = tomllib.loads((ROOT / ".codex/config.toml").read_text(encoding="utf-8"))
registered = [
    (ROOT / ".codex" / spec["config_file"]).resolve()
    for spec in config["agents"].values()
    if isinstance(spec, dict) and "config_file" in spec
]
if len(registered) != len(actual_agents) or set(registered) != actual_agents:
    errors.append("Codex agent registration differs from department agent prompts")

for agent, departments in owners["agents"].items():
    workspace_path = f".agents/departments/{departments[0]}/README.md"
    instructions = tomllib.loads(agent.read_text(encoding="utf-8")).get("developer_instructions", "")
    if workspace_path not in instructions:
        errors.append(f"{agent.relative_to(ROOT)} does not reference its department workspace")

entrypoints = {p.name: p for p in (ROOT / ".agents/skills").iterdir()}
skill_names = {p.parent.name for p in actual_skills}
if set(entrypoints) != skill_names:
    errors.append("Codex skill entrypoints differ from department skills")
for skill in actual_skills:
    entry = entrypoints.get(skill.parent.name)
    if entry is None or not entry.is_symlink() or entry.resolve() != skill.parent:
        errors.append(f"missing or incorrect skill discovery link: {skill.relative_to(ROOT)}")
    frontmatter = skill.read_text(encoding="utf-8").split("---", 2)
    if len(frontmatter) < 3 or not re.search(rf"(?m)^name:\s*{re.escape(skill.parent.name)}\s*$", frontmatter[1]):
        errors.append(f"skill name does not match folder: {skill.relative_to(ROOT)}")

if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
print(f"DEPARTMENT_MAP_OK: {len(actual_agents)} agents, {len(actual_skills)} skills, {len(ALL_DEPARTMENTS)} departments")
