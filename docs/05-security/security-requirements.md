# Security Requirements

- Email, Apple, and Google identities map to one durable internal user only after provider-side verification.
- Admin access is invitation-only with MFA, separate session scope, secure cookies, CSRF/origin protection, and DB-backed field/action permissions.
- Data-source access, Sportapp processing, AI sharing, coach sharing, notifications, and commercial messaging are separate decisions.
- Raw health records sent to AI require a separate versioned consent, approved provider/purpose, task-required categories and bounded time window; consent never defaults to full-history disclosure.
- Revocation must affect queued/running/future work and caches; hiding UI is insufficient.
- Initial P0 accepts no end-user AI keys or arbitrary custom URLs. Later provider/Ollama adapters require operator allowlisting plus HTTPS, SSRF/redirect/DNS/port/size/timeout/egress controls where applicable.
- Billing effects require verified provider evidence, environment separation, idempotency, reconciliation, and account-ownership checks.
- Health, secrets, private notes, and unnecessary payment payloads are prohibited from logs/events/analytics.
- Export/download is scoped, short-lived, reauthorized, audited, and CSV-injection safe.
- Account deletion cannot be undone by late events; legally required minimal financial retention is isolated.
- No client-provided role, tenant, permission, paid flag, price, or health-authorization claim is authoritative.
- Admin-configured AI, SMTP and S3-compatible storage secrets are write-only, vault-backed, masked after save, owner-scoped, step-up protected and audited. Connection tests must prevent SSRF and secret disclosure.
- Runtime provider secret ciphertext is stored in Neon and decryptable only by authorized backend integration paths using an environment root key held as a Cloudflare Worker Secret; key loss/rotation/recovery and plaintext-exclusion tests are mandatory.
- Ollama configuration accepts only a Worker-reachable HTTPS endpoint after DNS/address/redirect/port/timeout/size checks; browser-supplied localhost, LAN discovery, cleartext remote HTTP and unsafe redirects fail closed.
- Password/session/recovery implementation must use reviewed libraries and standards, with rate limits and replay resistance verified within Cloudflare Workers Free CPU constraints.
- EU-primary storage must not be represented as EU-only processing while Workers may execute globally.
- Admin-managed metadata/config/integration releases are typed, bounded, revision-checked, separately publish-authorized and audited. Config/flags never bypass authentication, authorization, consent, tenant isolation, provider capability ceilings, StoreKit/HealthKit authority, crypto or safety policy.
- App/public config endpoints expose only active compatible fields and exclude drafts, secret material/references, admin notes and internal verification evidence; stored localization/content is safely rendered and export-safe.
