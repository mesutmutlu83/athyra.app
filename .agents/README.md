# Department Agent Workspaces

Each department under [departments/](departments/) owns its skill source directories, an `OPERATING.md` for role-specific rules and process, and a `knowledge/` directory for verified agent workflow findings and lessons. The corresponding agent prompts live under [`.codex/agents/`](../.codex/agents/). Cross-department routing, decision, quality, knowledge, and weekly-scan rules live in the [governance workspace](departments/governance/README.md); its [knowledge base](departments/governance/knowledge/README.md) records shared agent-run lessons.

Canonical Sportapp product and system facts stay under [docs/](../docs/). Agent knowledge links to those facts when needed and never becomes a second product source of truth. The [knowledge-management process](departments/governance/processes/knowledge-management.md) defines evidence, ownership, review, and supersession.

The [skills/](skills/) directory contains only symlinks to department-owned skill directories because Codex discovers repository skills from `.agents/skills`. Edit the target in `departments/`, not the discovery link. `scripts/validate-department-map.py` checks that every entrypoint resolves to exactly one owner.
