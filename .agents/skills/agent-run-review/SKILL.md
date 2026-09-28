---
name: agent-run-review
description: Review evidence from completed agent work to decide whether a skill, agent prompt, or routing rule needs a narrow change.
---

Use with `docs/00-governance/agent-effectiveness.md` when a user correction, QA rejection, runtime surprise, repeated rework, or the monthly review exposes a possible agent-system problem. Product Manager owns routing decisions; Documentation Engineer maintains the evidence record.

Inspect the actual task result, relevant QA/review/runtime evidence, and the skill or prompt version used. Separate an implementation defect from a skill, prompt, routing, tool, or test-process defect. Record a sanitized evidence pointer and expected versus observed behavior. Do not copy raw transcripts, personal data, credentials, or speculative explanations into durable docs.

Change a skill or prompt only when observed evidence supports a concrete correction. State the expected improvement, edit the narrowest instruction, and verify it with a realistic replay or an equivalent check of the failure path. Record the outcome and any remaining uncertainty. If evidence is absent or the cause is unclear, record `no change` or an open hypothesis with an owner and next check; external examples alone do not justify a local prompt change.
