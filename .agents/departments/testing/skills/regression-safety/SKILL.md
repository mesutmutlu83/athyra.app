---
name: regression-safety
description: Prevent behavior regressions from code, schema, configuration, dependency, API, mobile, infrastructure, or shared-component changes using blast-radius analysis, preserve-invariants, targeted baseline/regression tests, compatibility checks, and compact evidence.
---

Use this skill for any change that can alter production behavior. Do not load it for pure explanation or documentation-only changes unless the documentation describes a behavior change that must be verified.

The goal is maximum regression protection with minimum unnecessary analysis/test scope.

## Compact regression algorithm

1. Identify `SURFACE`: changed files/symbols/contracts/schema/config/dependencies.
2. Identify `AFFECTED`: direct callers/importers/consumers, persisted data, user flows, jobs, integrations, platform paths, and shared components that can reasonably change behavior.
3. Identify `PRESERVE`: existing observable behaviors/invariants that must not change.
4. Identify existing tests covering `AFFECTED`/`PRESERVE`.
5. Establish a baseline before behavior changes when practical and risk-appropriate.
6. Implement the smallest safe change.
7. Add/update tests for new behavior and missing regression coverage.
8. Run targeted changed-path tests first; broaden based on blast radius and risk.
9. Record only compact regression evidence.

Do not run unrelated exhaustive analysis solely for ceremony. A shared/core/high-risk change warrants broader coverage than an isolated low-risk change.

## Regression packet

Use this compact packet only when a production behavior change exists:

```text
REGRESSION:
RISK: LOW | MEDIUM | HIGH
SURFACE: <paths/symbols/contracts>
AFFECTED: <existing behaviors/components>
PRESERVE: <invariants>
TESTS: <baseline/new/regression checks>
BLOCKERS: <only if any>
```

Omit empty fields. Prefer IDs/paths/test names over prose. Do not paste test logs when a summary is enough.

## Single-owner evidence rule

Maintain one task-level regression packet, not one full report per role.

- PM sets only initial risk.
- Specialists contribute only role-specific `ADD`, `CORRECT`, or `BLOCK` deltas.
- Implementer(s) update the concrete surface/affected/preserve/tests fields for their layer.
- For multi-layer work, the parent/orchestrator merges local deltas into one packet.
- QA independently validates that single packet and reports gaps/results; it does not rewrite the same analysis.
- Code Reviewer checks plausibility from the diff and QA evidence; it should not rerun the same behavioral analysis unless evidence is missing.

## Baseline rules

- For a bug: when practical, create or identify a regression test that fails on the buggy behavior before applying the fix, then passes after the fix.
- If a pre-fix failing test cannot reasonably be created, state the reason briefly and verify the failure through the smallest reproducible evidence available.
- For a feature/change: identify existing tests for affected behavior before changing it. Run a pre-change baseline when risk is MEDIUM/HIGH, the code is shared/core, or a later comparison would otherwise be ambiguous.
- For LOW-risk isolated changes, a pre-change full suite is not required; targeted post-change evidence may be sufficient.

## Blast-radius rules

Inspect only plausible dependencies, not the entire repository by default.

Check as applicable:
- direct imports/callers/callees;
- shared interfaces/types/contracts;
- API consumers;
- persisted schema/data;
- shared UI components/state;
- queues/events/jobs/webhooks;
- caches/search indexes;
- auth/RBAC/tenant boundaries;
- platform-specific mobile integration;
- deployment/runtime configuration;
- dependency/version behavior.

Escalate regression risk when changing shared/core code, public contracts, authentication/authorization, tenant isolation, data models/migrations, concurrency/transactions, common UI primitives, platform lifecycle, infrastructure, or widely reused libraries.

## Test breadth

Use risk-based expansion:

- LOW: changed-path tests + direct affected regression tests.
- MEDIUM: LOW + affected integration/contract tests + nearby impacted flows.
- HIGH: MEDIUM + broader subsystem/end-to-end/compatibility checks as available; full relevant suite/CI gate when justified.

Do not equate "all tests passed" with sufficient coverage if the affected behavior was never tested.
Do not run an unrelated full suite simply to create evidence when targeted coverage is stronger and risk is low.

## Pre-existing failures

A failing test may be classified as pre-existing only with evidence, such as:
- a pre-change baseline failure;
- unchanged failing behavior reproducible on the base revision;
- existing documented failure with trustworthy evidence.

Do not waive a failure merely because it looks unrelated.
Do not repair unrelated pre-existing failures unless required for the requested work; report them compactly.

## Role-specific expectations

### Product Manager
Classify regression risk and route only required roles. Do not perform deep blast-radius analysis.

### Product Owner
Define important `PRESERVE` behavior in acceptance criteria when changing existing behavior.

### System Architect
For architecture/contract changes, identify compatibility boundaries and high-impact blast radius; avoid implementation-level exhaustive dependency tracing.

### UX/UI
When an existing flow changes, preserve unaffected navigation/state/accessibility behavior and identify shared design-system impact.

### Frontend
Check shared component/state/API consumers, routing, loading/error/permission states, accessibility, and affected browser flows.

### Backend
Check API/domain callers, contracts, async jobs/events, transactions, integrations, authorization, and failure behavior.

### Android/iOS
Check affected supported OS/device behavior, lifecycle/background-resume, navigation/deep links, permissions, offline/cache, auth refresh, push when relevant, and app upgrade/stored-state compatibility.

### Database
Check schema/data compatibility, constraints/indexes, old data, new data, forward migration and recovery/rollback. For rolling deployments, verify old-app/new-schema and new-app/transitional-schema compatibility when applicable. Prefer expand/migrate/contract patterns when risk warrants them.

### Security
Ensure regression does not weaken existing security controls, authorization, isolation, validation, or secret handling.

### DevOps/SRE
Check backward-compatible config/runtime/deployment behavior, rollout, health/readiness, rollback, and observability when affected.

### QA
Independently validate the developer's regression packet. Expand the scope only when the packet misses plausible affected behavior. QA approval requires sufficient regression evidence for the actual risk.

### Code Reviewer
Review whether the stated blast radius and tests are credible from the diff/surrounding code. Reject if a plausible regression path is untested or compatibility is silently broken.

## Release requirement

A behavior-changing release is blocked unless regression evidence identifies:
- change surface;
- affected existing behavior;
- preserved invariants or a justified statement that none exist;
- relevant executed tests/checks;
- disposition of any failures.

Brevity/token optimization must never override regression safety; increase analysis only when evidence/risk requires it.
