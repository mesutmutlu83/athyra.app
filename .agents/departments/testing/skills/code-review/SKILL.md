---
name: code-review
description: Independently review a code diff for correctness, requirement fit, regressions, security, data integrity, architecture, performance, test quality, configuration hygiene, and unnecessary complexity.
---

Use `regression-safety` for behavior-changing diffs.
Review the actual diff plus enough surrounding code to understand execution paths.
Find concrete defects before style preferences.
Check:
- requirement mismatch;
- correctness/regression;
- security;
- auth/permissions;
- data/transaction/concurrency;
- error and partial-failure handling;
- resource/performance risk;
- tests;
- hard-coded configurable values;
- architecture boundary violations;
- unnecessary dependencies or scope creep.

Give actionable file/symbol-specific findings.

Reject when the claimed blast radius is implausibly narrow, preserved behavior is silently broken, or relevant regression evidence is missing.
