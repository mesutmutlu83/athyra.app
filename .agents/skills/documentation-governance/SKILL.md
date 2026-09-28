---
name: documentation-governance
description: Maintain the fixed docs information architecture and ensure persistent product, UX, architecture, engineering, security, testing, operations, and release documentation matches the implemented system.
---

Read `docs/README.md`.
Use `knowledge-management` and `docs/00-governance/knowledge-management.md` for verified findings, reusable lessons, stale claims, or external evidence that changes canonical guidance.
Put durable information only in its canonical location.
Feature-specific material belongs under `docs/features/<FEATURE-ID>/`.
Architecture decisions belong in ADRs.
Do not duplicate the same source-of-truth across many files; link instead.
Do not promote temporary notes/logs into persistent docs.
Reconcile docs against actual implemented/tested behavior before release.
