# Quality Gates

1. Requirement Gate — Product Manager/Product Owner.
2. Design Gate — UX/System Architecture/Data/Security as applicable.
3. Implementation Gate — scoped code plus focused tests.
4. Regression Gate — required for production behavior-changing work; compact evidence must cover surface, affected behavior, preserve-invariants and executed checks.
5. QA Gate — independent verification for every production code change; `QA_APPROVED` required.
6. Code Review Gate — `CODE_REVIEW_APPROVED` required for L2/L3 and risk-triggered L1 only.
7. Documentation Gate — affected canonical docs reconciled when durable behavior, contracts, decisions, or verified knowledge/lessons changed; stale or conflicting claims are labeled and owned.
8. Release Gate — configured quality commands + all applicable approvals.

For actual merge/deployment enforcement, configure CI required checks and branch protection.
