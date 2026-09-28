# ADR-009: Envelope-Encrypted Runtime Secrets

- Status: Accepted with implementation/recovery validation
- Date: 2026-09-25
- Decision owner: Product owner
- Related feature(s): FEAT-001

## Context

Authorized owners must configure Ollama, SMTP and S3-compatible provider credentials through the private admin without committing secrets or exposing them to browser/mobile clients. Cloudflare deployment secrets alone do not provide the required runtime-administered provider inventory.

## Decision

Store provider secret ciphertext and non-sensitive key metadata in Neon. Keep the environment-specific root key only in a Cloudflare Worker Secret. Use a reviewed authenticated-encryption/envelope scheme implemented through established platform cryptography, with a fresh nonce, versioned key ID and context-bound additional authenticated data per secret record.

The admin API accepts secret replacement through an owner-only, recent-MFA/step-up operation. It never returns plaintext after save; the UI receives only presence, version and last-verified metadata. Decryption is limited to the backend integration operation that needs the credential. Audit events record actor, provider, action, version and result but never secret values.

## Consequences

- Development, preview and production use distinct root keys and ciphertext records.
- Root-key rotation supports re-encryption/rewrapping with resumable progress and rollback; old keys remain available only for the bounded rotation window.
- Losing the only root key makes ciphertext unrecoverable. Key provisioning, protected recovery material, rotation and disaster-recovery tests are production gates.
- Database export alone does not expose provider credentials, but a compromised Worker with decrypt permission remains a critical trust boundary.

## Rollback or migration

Provider credentials can be replaced without changing provider identity or non-secret configuration. A future external secret manager may replace this mechanism through opaque secret references and a controlled migration.
