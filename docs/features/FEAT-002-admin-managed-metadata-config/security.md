# FEAT-002 Security

## Trust boundaries

Admin browser, Hono admin API, Neon release store, Workflows, public app-config API, iOS cache and external provider endpoints remain separate trust boundaries.

## Required controls

- Invitation-only admin MFA, secure session/CSRF/origin controls and recent step-up for secret, publish and rollback actions.
- DB-backed deny-by-default field/action permissions; `WRITE` never implies `PUBLISH`.
- Provider capability ceiling enforced from adapter/evidence, never admin claims alone.
- Typed allowlisted definitions and bounded values; no arbitrary code, SQL, privileged headers, scripts or system prompts.
- ADR-009 write-only secret handling; no plaintext in response, audit, diff, event, log or public config.
- SSRF/DNS/redirect/port/size/timeout controls for endpoint verification.
- Public snapshots exclude drafts, internal evidence, admin notes, secrets and privileged fields.
- Audit is immutable/tamper-evident in application terms and contains no health payload.
- Bulk changes, verification and publish endpoints are rate/resource bounded and idempotent.

## Abuse cases

- CRM user attempting config publish; editor attempting self-elevation; stale publisher permission; guessed foreign change-set ID.
- Unsupported Samsung/iOS or other capability force-enabled by admin.
- Consent, StoreKit, HealthKit entitlement or safety hard limit disabled via config.
- Secret exfiltration through read API, diff, connection test, error or audit.
- SSRF through Ollama/S3/SMTP/provider endpoint and DNS rebinding after validation.
- Malicious localization/content causing stored XSS, formula injection or unsafe downstream rendering.
- Rollback to a schema/provider state incompatible with live clients/connections.

## Review status

Design controls accepted; implementation security review and negative-test evidence are pending.
