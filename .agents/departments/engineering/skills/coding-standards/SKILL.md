---
name: coding-standards
description: "Apply repository-wide software engineering standards: maintainable design, SOLID/KISS/YAGNI, configuration hygiene, error handling, boundaries, dependency discipline, and change-scope control."
---

Apply:
- clear module ownership and separation of concerns;
- simple design;
- SOLID where useful, not ceremonial;
- KISS, YAGNI, and pragmatic DRY;
- composition over inheritance by default;
- explicit side effects and errors;
- typed/stable contracts when supported;
- input validation at trust boundaries;
- no secrets or environment/business-configurable values hard-coded in application logic;
- no hidden global mutable state;
- no unrelated drive-by refactors;
- no dead/commented-out code;
- no speculative abstractions;
- existing formatting/lint conventions.

A code constant is acceptable only when it is intrinsic to the domain/protocol, not operational/business configuration.
