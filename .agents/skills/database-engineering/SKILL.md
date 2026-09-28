---
name: database-engineering
description: Design/review relational or non-relational data models, constraints, migrations, indexes, queries, transactions, concurrency, retention, backup, and recovery.
---

Use `regression-safety` for schema/data behavior changes, including migration/data compatibility.
Base schema/index decisions on actual access patterns and integrity requirements.
For multi-tenant/RBAC systems, treat tenant membership, role/permission assignments, and authorization-relevant lifecycle state as durable DB-backed state and enforce tenant integrity with keys/constraints/indexes where practical.
Prefer database constraints for invariants that must always hold.
Use migrations and document rollout.
Prefer additive/backward-compatible changes.
Treat destructive cleanup as a separate controlled step where possible.
Consider isolation, locks, long transactions, and online migration behavior.
Verify backup/restore impact for critical changes.
Destructive production changes require human approval.
