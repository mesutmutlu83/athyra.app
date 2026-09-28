# ADR-003: Managed CIAM with Application-Owned Authorization

- Status: Superseded by ADR-007
- Date: 2026-09-25
- Decision owners: Product owner
- Related feature(s): FEAT-001

## Context

P0 requires email/password, Sign in with Apple and Google Sign-In for one durable Sportapp user. Admin access requires invitation-only MFA and must not inherit athlete/coach privileges.

## Decision

Use a managed CIAM for authentication, credential recovery and identity-provider federation. Persist the internal user, external identity mappings, memberships, roles, permissions, lifecycle status and audit history in the Sportapp PostgreSQL database. Resolve authorization server-side and deny by default.

Admin MFA should prefer phishing-resistant passkey/WebAuthn when the selected CIAM supports the required clients, with a reviewed recovery mechanism and TOTP fallback. Social login alone is not admin MFA.

## Consequences

- CIAM selection must verify native iOS and web SDK maturity, Apple/Google token validation, account linking, MFA/recovery, export/migration, region, DPA, pricing and incident controls.
- Email equality never automatically merges identities.
- Role or membership changes require server-side invalidation; client claims are cached hints only.
- Account deletion includes CIAM lifecycle actions without deleting externally owned health records.

## Security / data / operations impact

Secrets remain server-side. Redirects, audiences and keys are environment-specific. Admin and consumer sessions remain separately scoped and audited.

## Rollback or migration considerations

Keep provider subject mappings and internal user IDs separate so CIAM migration does not rewrite product ownership or history.
