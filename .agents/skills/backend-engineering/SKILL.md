---
name: backend-engineering
description: Implement/review backend APIs, domain logic, integrations, workers, reliability controls, security boundaries, configuration, and tests using the detected stack.
---

Use `regression-safety` for behavior-changing backend work.
Keep domain rules explicit.
Validate input and external output.
Enforce authorization server-side using authoritative membership/permission/resource scope. Treat client tenant/role/permission claims as untrusted until validated.
Use stable error contracts.
Use timeouts for remote calls.
Retries must be bounded, backoff-aware, and safe for the operation.
Use idempotency where duplicates are plausible.
Respect transaction boundaries.
Avoid unbounded work/queues/fan-out.
Make configuration explicit and validated.
Add structured observability at important boundaries.
