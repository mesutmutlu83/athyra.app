# Regression Strategy

## Principle

Every production behavior change gets risk-based regression analysis and evidence. The scope is proportional to blast radius.

## Workflow

```text
change surface
  -> affected existing behavior
  -> preserve invariants
  -> baseline when useful
  -> smallest implementation
  -> targeted tests
  -> affected regression tests
  -> broader tests only when risk warrants
  -> independent QA
  -> review when required by routing
```

## Risk levels

- LOW: isolated, no shared contract/data/security/platform impact.
- MEDIUM: multi-file/shared behavior, API/UI interaction, ordinary migration/integration.
- HIGH: auth/RBAC/tenancy, shared core, public contract, risky migration, concurrency, cross-platform lifecycle, infrastructure, security/privacy, destructive behavior.

## Evidence

Use the compact `REGRESSION` packet defined by the `regression-safety` skill. Do not paste large logs into agent messages. Store temporary detailed logs under `tmp/` when needed.

## Bug fixes

Prefer a test that demonstrates the bug before the fix and passes after it. If not practical, retain the smallest reproducible pre/post evidence and state why a failing pre-fix automated test was not feasible.

## Pre-existing failures

A failure is pre-existing only when supported by baseline/base-revision/documented evidence. Otherwise it remains unresolved.

## CI

The repository quality gate remains authoritative for configured suites. A dedicated regression command is optional and should only be configured when it is distinct/useful; do not duplicate the same large suite under multiple command names.
