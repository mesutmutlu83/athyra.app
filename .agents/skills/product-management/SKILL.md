---
name: product-management
description: Define and maintain software-product scope, feature requirements, acceptance criteria, prioritization context, traceability, and durable feature documentation.
---

For a meaningful feature:
- identify actors, tenant scope, required permissions, and ownership rules when applicable;
- identify shared foundation impact (identity/RBAC, audit, settings, notifications, files, flags, API conventions, jobs);
1. Assign/use a stable feature ID.
2. Create or update `docs/features/<FEATURE-ID>/`.
3. Keep problem/outcome separate from implementation proposal.
4. Define functional requirements with stable IDs when traceability matters.
5. Define observable acceptance criteria.
6. Define explicit out-of-scope items.
7. Capture relevant edge/negative cases.
8. Link requirements to UX, architecture, security, and tests.
9. Record unresolved product decisions rather than guessing.
10. Keep persistent product truth in docs, not only chat.
