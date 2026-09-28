---
name: release-gate
description: Final software delivery gate that verifies applicable acceptance, QA/review, regression, quality, security/data/ops, documentation, hygiene, and release requirements before declaring work complete.
---

The root Delivery Orchestrator owns this final gate. Other roles provide evidence and should not independently repeat the entire gate.

A release is blocked unless all applicable items in AGENTS.md Release Gate are satisfied.

Require explicit evidence for:
- acceptance criteria;
- executed quality checks;
- QA status;
- code review status only when required by adaptive routing/risk;
- regression evidence for production behavior-changing work;
- security/architecture/database review when triggered;
- docs updates only when durable documented behavior/contracts/architecture changed;
- affected domain knowledge/lessons assessed and verified findings reconciled under `docs/00-governance/knowledge-management.md`;
- release notes only when required by repository release policy/user-visible change;
- absence of accidental temporary artifacts/secrets.

Run `scripts/quality-gate.sh` when implementation changed production code and the repository gate is configured. Use `regression-safety` to verify compact regression evidence; do not rerun duplicate suites solely to satisfy labels.
Never infer a pass from the absence of an error report.
Return `RELEASE_GATE_PASSED` only when all applicable checks pass.
Otherwise return `RELEASE_GATE_BLOCKED` with reasons.
