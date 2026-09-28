# Rule Precedence

When instructions appear to compete, apply this order:

1. Human approval / destructive-action / safety and security gates.
2. Correctness, data integrity, tenant isolation, regression safety, and required independent verification.
3. Explicit approved product requirements and acceptance criteria.
4. Architecture/engineering conventions and compatibility requirements.
5. Adaptive orchestration: minimum necessary roles and checks.
6. Token/context/output efficiency and stylistic brevity.

Token efficiency may reduce unnecessary agents, duplicated context, test-log output, or ceremonial documentation. It must never remove a check that is required by actual risk, acceptance criteria, security, data integrity, or regression safety.

When a lower-priority rule conflicts with a higher-priority rule, follow the higher-priority rule and record only the smallest useful explanation.
