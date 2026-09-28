# FEAT-001 Test Plan

Source acceptance scenarios: T001–T220 in `docs/01-product/project-brief.md`.

Current status: all `NOT_RUN`; no application, test framework, environment, external account, or physical-device evidence is present.

Use `docs/06-testing/test-strategy.md`, `test-matrix.md`, and `traceability.md`. Record mocks, synthetic data, real provider sandbox tests, physical-device tests, browser E2E, signed archive checks, and production evidence as distinct statuses.

Mandatory focused evidence includes:

- pinned iOS 15 dependency graph, privacy manifests, signed archive and physical-device coverage;
- Apple identity token plus authorization-code exchange, first-login-only fields and account-deletion revoke;
- Google signing-key rotation, issuer/audience/expiry/nonce rejection and separation from health/data OAuth scopes;
- StoreKit sandbox purchase/trial/restore/refund/revocation/account switch, signed Notifications V2/API reconciliation, duplicate/out-of-order delivery and entitlement ownership conflicts;
- Worker Free CPU/quota measurements for password hashing, Apple/Google/JWS verification, session issuance, durable inbox recording and shared rate limiting;
- raw-health AI consent/version recheck immediately before dispatch and fail-closed behavior after revocation;
- Ollama HTTPS endpoint validation, DNS rebinding/SSRF/redirect denial, authentication masking, capability probing, structured-output rejection, timeout/size limits and unavailable-provider behavior;
- envelope-encrypted secret round-trip, wrong-context/key failure, root-key rotation/recovery and absence of plaintext in API responses, DB fields, audit and logs;
- S3-compatible provider switch/migration under concurrent write/delete, partial failure, checksum mismatch, credential rotation and rollback.
- Neon Free and Hyperdrive capacity/quota behavior; automated encrypted 35-day external backup, checksum verification and isolated restore drill are deferred but mandatory before production data.
