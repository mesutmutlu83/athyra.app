# Threat Model

## High-value assets

Account/session material, health/activity records, goals and plans, coach-private notes, consent history, AI credentials/context, staff permissions, payment evidence, CRM/support content, exports, and audit evidence.

## Priority abuse cases

- Cross-athlete or cross-role access, IDOR, stale/revoked coach access, and admin privilege escalation.
- Account takeover, identity-linking collisions, replayed callbacks/tokens, and unsafe account switching on one device.
- Health import after consent revocation or under the wrong account/install epoch.
- Ollama credential leakage, prompt-driven policy bypass, cross-user cache reuse, and SSRF/DNS-rebinding through the operator-configured endpoint; later provider adapters inherit the same threat boundary.
- Forged/duplicate/out-of-order billing evidence, sandbox-to-production contamination, and entitlement races.
- Stored XSS/CSV injection through CRM/support fields; CSRF and overly broad admin cookies.
- Sensitive logging/export URLs, deletion resurrection through late events, and excessive retention.
- Catalog/content rights violations or unreviewed content presented as validated coaching.

Mitigations are requirements, not implementation evidence: server-side deny-by-default authorization, scoped MFA/step-up, consent re-evaluation, secret vaulting, egress controls, idempotency/versioning, provider verification/reconciliation, safe rendering/export, minimized retention, immutable audit, and negative tests.
