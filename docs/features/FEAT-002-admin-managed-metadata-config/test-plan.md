# FEAT-002 Test Plan

All results are `NOT_RUN`; no product implementation exists.

| Area | Required evidence |
|---|---|
| Lifecycle | Draft invisibility, validation failure, atomic publish, concurrent-edit conflict, prior-release rollback |
| Historical integrity | Rename/deprecate/replacement preserves plan snapshots, activity provenance and mapping version |
| Capability truth | Admin cannot publish capability above adapter/provider/OS verified ceiling |
| Integration states | Visibility, new connection, backend enabled, maintenance and each existing-connection behavior remain independent |
| Config safety | Type/range/scope/schema/app-version validation; auth/consent/StoreKit/safety bypass rejected |
| Client fallback | ETag/304, unknown-field tolerance, incompatible-schema handling, last-known-good and bundled defaults |
| Authorization | Read/write/publish separation; CRM/support denial; revoked/stale permission; IDOR/cross-scope denial |
| Secrets/SSRF | Write-only secret and log/diff exclusion; unsafe URL/DNS/redirect/port blocked; safe synthetic verification |
| Cache/performance | Version-key invalidation, stampede prevention, paged catalog, bounded bulk operations |
| Regression | FEAT-001 identity, plans, adaptation, coach, billing, CRM, consent and catalog behaviors preserved |

The source extension scenarios `TAX-ADM-01..05`, `INT-ADM-01..05`, `CFG-ADM-01..05`, `SEC-ADM-01..04` and `REG-ADM-01` are mandatory traceability inputs.
