---
name: documentation-governance
description: Maintain the fixed docs information architecture and ensure persistent product, UX, architecture, engineering, security, testing, operations, and release documentation matches the implemented system.
---

Read `docs/README.md`.
At project bootstrap, use `project-bootstrap` and the shared app-doc manifest. Require every skeleton document and the per-document `docs/01-product/document-coverage.md` register. Review each source Markdown against every existing app Markdown file, including dynamic decisions, ADRs, features, and source extensions; keep missing facts, conflicting claims, owner decisions, and unverified implementation claims visible until resolved. Do not accept a generated `needs_review` row as a completed source audit.
Keep application facts, requirements, architecture, test evidence, operations, and release records under `docs/`. Keep agent prompts, skills, operating rules/processes, agent-run findings, and lessons under `.agents/departments/`. Do not place agent-system records in app documentation; link across the boundary only when useful.
Use `knowledge-management` and `.agents/departments/governance/processes/knowledge-management.md` for verified findings, reusable lessons, stale claims, or external evidence that changes canonical guidance.
Put durable information only in its canonical location.
Feature-specific material belongs under `docs/features/<FEATURE-ID>/`.
Architecture decisions belong in ADRs.
Do not duplicate the same source-of-truth across many files; link instead.
Do not promote temporary notes/logs into persistent docs.
Reconcile docs against actual implemented/tested behavior before release.
