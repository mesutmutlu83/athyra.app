---
name: testing-quality
description: Build a risk-based test strategy from acceptance criteria, add regression/automation coverage, execute configured checks, and provide evidence-based QA approval or rejection.
---

Use `regression-safety` for production behavior changes.
Map requirements/acceptance criteria to tests.
For RBAC/multi-tenant behavior, build an actor x tenant x permission x resource-scope matrix and include negative cross-tenant/privilege tests.
Cover happy path, boundaries, failures, permissions, and regressions relevant to the change. Independently validate the stated change surface/affected behavior; expand only where plausible gaps exist.
Prefer deterministic tests.
Mock only at meaningful boundaries.
For defects, create or verify a regression test that demonstrates the defect before the fix when practical.
Do not use coverage percentage as the sole quality signal.
Run the configured project checks and report exactly what ran.
For installed scheduled jobs, verify the rendered job's actual arguments, trigger, and loaded state after installation; template lint and mocked runner checks alone do not prove the installed job will start correctly.
Do not approve with known applicable failures.
