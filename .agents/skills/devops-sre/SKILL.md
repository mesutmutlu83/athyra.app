---
name: devops-sre
description: Design/review CI/CD, environments, containers, deployment, rollout/rollback, health checks, observability, reliability, capacity, configuration, and operational runbooks.
---

Use `regression-safety` for behavior-changing runtime/config/deployment/infrastructure work.
Make build/release repeatable.
Keep secrets outside source control.
Use immutable/reproducible artifacts where practical.
Define health/readiness semantics.
Plan safe rollout and rollback.
Add structured logs/metrics/traces where useful.
Bound resources and network calls.
Wire the same quality gate into CI.
Production-changing actions require explicit human approval.
Material infrastructure topology/vendor/cost/security changes require Human Decision Gate.
