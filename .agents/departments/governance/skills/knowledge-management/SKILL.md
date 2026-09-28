---
name: knowledge-management
description: Keep each domain's canonical knowledge and reusable lessons current when work or verified external evidence changes what the team knows.
---

Use with `.agents/departments/governance/processes/knowledge-management.md` and `docs/README.md` when a task changes durable knowledge, exposes a reusable lesson, or produces material external evidence.

1. Read the canonical document for the affected domain before making a claim or edit. The assigned domain specialist owns accuracy; Documentation Engineer reconciles cross-domain changes.
2. Trigger a knowledge check during intake, implementation/research, QA/review, and handoff when a change, incident, test failure, user finding, or credible new source affects an existing fact, decision, constraint, or practice. Do not wait for a release if the finding is already verified.
3. For each material delta, record the claim, scope, owner, evidence/link, observed or checked date, confidence/status, and impact on existing docs. Link the canonical decision or implementation instead of copying it into a second source of truth.
4. Separate observed facts, third-party claims, hypotheses, and approved decisions. External information enters as a candidate. Verify with current primary sources and the actual repository/runtime before promoting it to canonical guidance. Recheck time-sensitive claims when the task depends on them.
5. Correct or supersede stale/conflicting information in the same task. If evidence is insufficient, mark the item open with owner and next check; never silently overwrite an approved product, architecture, security, or data decision.
6. Record a lesson only when it includes a concrete trigger, evidence, consequence, and a reusable action or guardrail. Avoid chat transcripts, routine status notes, and duplicate feature details.
7. Writable roles update their owned canonical docs as part of the task. Read-only roles return a source-backed delta for the owner. The root checks relevant documentation at final handoff.

This workflow is event-driven during agent work. The separate `weekly-knowledge-scan` skill defines the bounded recurring research cycle; neither workflow claims continuous internet monitoring.
