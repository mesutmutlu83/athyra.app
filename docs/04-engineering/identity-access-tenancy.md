# Identity, Access Control and Multi-Tenancy

This is the canonical engineering contract for user/tenant/RBAC behavior.

## Source of truth

ADR-007 selects application-owned identity and sessions in Neon, while Apple and Google remain external identity issuers. Application authorization is server-side and durable.

The database should hold, as applicable:
- application user mapping/profile;
- credential metadata, external provider-subject mappings, sessions and one-time recovery state;
- organization/tenant/workspace;
- membership;
- membership/account state;
- roles;
- permissions;
- role-permission mappings;
- scoped role assignments;
- resource ownership where access depends on ownership;
- invitations;
- authorization-relevant audit records.

Tokens/claims are transport/cache mechanisms, not the mutable canonical authority.

## Conceptual relationships

```text
User
  |
  +-- Membership -- Tenant
          |
          +-- Role Assignment -- Role -- RolePermission -- Permission

Tenant
  |
  +-- Tenant-owned resources
          |
          +-- optional Owner/User relationship
```

Adapt names to the domain. Do not copy this schema blindly.

## Authorization request path

```text
Authenticated identity
        ↓
Validated tenant/scope context
        ↓
Membership/status
        ↓
Effective permission
        ↓
Resource tenant/ownership validation
        ↓
Domain operation
        ↓
Audit security-sensitive changes
```

## Tenant data rules

- Scope tenant data explicitly.
- Use tenant-aware uniqueness/indexes where appropriate.
- Prevent cross-tenant references with constraints/design where practical.
- Do not use object ID secrecy as an authorization control.
- Propagate tenant context safely through jobs, caches, search indexes, exports and storage.
- Client-sent tenant IDs are not authorization evidence.

## Client rules

Web/Android/iOS may receive effective capabilities and use them for:
- navigation;
- button/action visibility;
- disabled/permission states;
- explanatory UX.

Server APIs still authorize every protected operation.

## Change propagation

Document how role/membership revocation affects:
- active sessions;
- access tokens/claims;
- caches;
- background work;
- websocket/subscription connections;
- offline mobile state.

## Audit

At minimum, consider auditing:
- member invited/accepted/removed;
- role granted/revoked;
- permission model changed;
- security-sensitive setting changed;
- admin impersonation/delegation if supported.

Never audit secrets/tokens/passwords.

## Admin-managed configuration permissions

FEAT-002 separates `READ`, `WRITE` and `PUBLISH` for metadata, integrations and product configuration, plus dedicated AI-config and audit-read permissions. Editing a draft never grants publication. Publish/rollback requires recent MFA/step-up, reason and audited expected-version checks. CRM, support, finance or metadata roles do not inherit health-data or secret-plaintext access.

## Testing

Maintain tests for:
- allowed access;
- denied access;
- user with no membership;
- suspended/removed membership;
- wrong tenant;
- guessed resource ID / IDOR;
- role change/revocation;
- ownership mismatch;
- privileged administrative actions.
