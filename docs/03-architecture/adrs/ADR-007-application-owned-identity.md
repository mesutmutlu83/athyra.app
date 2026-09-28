# ADR-007: Application-Owned Identity and Sessions

- Status: Accepted with feasibility/security-validation gate
- Date: 2026-09-25
- Decision owner: Product owner
- Supersedes: ADR-003
- Related feature(s): FEAT-001

## Context

The initial release needs email/password, Apple and Google sign-in, recovery, linking, sessions and invitation-only admin MFA. The product owner requires a no-license-cost system operated by Sportapp instead of a paid CIAM dependency.

## Decision

Keep users, verified identities, credential metadata, sessions, recovery state, memberships, roles and permissions in Neon PostgreSQL. Native iOS uses the official Apple/Google client flows; the API validates issuer, audience, nonce, expiry and signatures server-side and maps provider subjects to durable internal users. Email equality never silently links accounts.

For Sign in with Apple, iOS sends both the identity token and single-use authorization code over authenticated HTTPS. The backend exchanges the code with Apple, stores any refresh token encrypted behind the approved secret mechanism, and revokes the Apple token during account deletion before local identity removal. Apple's email/name may appear only on first authorization and must be handled without using email as the stable identity key.

For Google authentication-only scope, iOS sends the official SDK ID token to the backend. The backend validates rotated signing keys, issuer, server-client audience, expiry and nonce where present. A plain Google user ID or email is never authentication evidence. Google health/Drive permissions and tokens are separate and out of scope.

Email/password, session, recovery and MFA primitives must come from reviewed, actively maintained libraries and standards. Do not invent cryptography or token formats. Credential hashes, recovery tokens and session secrets are never readable through admin tools or logs. Admin access is invitation-only with separate session scope and MFA; social sign-in alone is not admin MFA.

Before implementation selection, run a Worker Free feasibility spike for password hashing, token verification, session issuance and rate limiting. A library is accepted only if it supports the chosen Worker runtime and native iOS protocol flow without weakening security.

Rate limits must use a shared/durable mechanism rather than isolate memory. Auth endpoints fail closed when required quota or verification dependencies are unavailable.

## Selected first implementation candidate

Use Hono + Better Auth + Drizzle against Neon as the first self-hosted, no-license-cost implementation candidate. Release approval still requires Cloudflare Workers compatibility, native iOS Apple/Google token flows, account-deletion revoke support, explicit disabling of unsafe email-based automatic linking, admin MFA/recovery controls, maintained dependencies and measured Free-tier CPU headroom. Failing any gate requires another reviewed library or a topology/plan change; security controls may not be weakened to fit the Free tier.

## Consequences

- There is no CIAM subscription, but Sportapp owns patching, abuse controls, deliverability, recovery, incident response and migration.
- Gmail/SMTP provides verification and recovery email through the configured adapter; authentication remains unavailable if required delivery cannot be verified.
- Admin changes to users, roles, sessions or recovery state require strong authorization and audit.
- Passkeys may be added later behind the same internal user and identity mapping.

## Rollback or migration

Internal user IDs stay independent from provider subjects and credentials. This permits later migration to a managed identity service without rewriting product ownership or history.
