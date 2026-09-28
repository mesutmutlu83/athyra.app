---
name: architecture-design
description: Design or review software architecture, service/module boundaries, interfaces, data flow, integrations, scalability, reliability, migrations, and ADRs.
---

For changes to existing architecture/contracts, use `regression-safety` to preserve compatibility without exhaustive implementation-level tracing.
1. Inspect the current architecture first.
2. Inspect existing identity/RBAC/tenant and shared foundation implementations before designing duplicates.
2. State requirements and constraints.
3. Prefer the smallest change that satisfies them.
4. Identify affected boundaries/contracts.
5. Evaluate failure modes, data consistency, security, operability, and backward compatibility.
6. Compare alternatives only when a real choice exists.
7. Use an ADR for a material decision.
8. Trigger Human Decision Gate for major technology/topology/vendor/data-store choices or breaking contracts.
9. Do not create architecture for hypothetical future needs without evidence.
