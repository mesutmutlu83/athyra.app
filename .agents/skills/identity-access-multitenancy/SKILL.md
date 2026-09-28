---
name: identity-access-multitenancy
description: Design or review DB-backed users, organizations/tenants, memberships, RBAC/permissions, authorization, ownership, invitations, sessions/claims, tenant isolation, auditability, and cross-tenant security for SaaS, web, API, and mobile applications.
---

Use this skill whenever a feature touches users, organizations/workspaces/tenants, roles, permissions, ownership, invitations, authentication claims, authorization, admin delegation, or tenant-scoped data.

## Core rule: authorization state is server/DB backed

Authentication may be delegated to an external identity provider, but application authorization must have a durable server-side source of truth.

Persist the applicable concepts in the application's database:
- application user/profile identity mapping;
- tenant / organization / workspace;
- membership between user and tenant;
- membership/account lifecycle status;
- role definitions;
- permission definitions;
- role-to-permission mapping;
- user/membership-to-role assignment;
- exceptional direct grants/denies only when the product truly needs them;
- resource ownership when ownership affects access;
- invitations and invitation lifecycle;
- authorization-relevant audit history.

Do not make hard-coded role-name checks such as `if role == "admin"` the primary authorization design for a product expected to evolve. Prefer permission/capability checks resolved server-side.

Tokens/claims may carry cached authorization context for performance, but they are not the canonical mutable source of truth. Define revocation/invalidation/versioning behavior when role or membership changes must take effect before token expiry.

## Recommended conceptual model

Adapt names to the product rather than copying mechanically.

- `users`
- `tenants` / `organizations` / `workspaces`
- `memberships`
- `roles`
- `permissions`
- `role_permissions`
- `membership_roles` or equivalent scoped assignment
- `invitations`
- `audit_events`

Optional only when required:
- direct permission grants/denies;
- groups/teams and group-role assignment;
- resource-level ACLs;
- delegated administration;
- service accounts;
- API keys;
- device/session registry.

Keep authentication identity separate from tenant membership. A user may exist without belonging to every tenant, and the same user may have different roles in different tenants.

## Permission design

Prefer permissions that describe capabilities, for example:
- `project.read`
- `project.create`
- `project.update`
- `project.delete`
- `member.invite`
- `member.role.assign`

Keep display labels separate from immutable permission identifiers.
Avoid UI route names as permission identifiers.
Avoid permissions whose semantics depend on hidden client behavior.

Define scope explicitly:
- system/global;
- tenant;
- resource;
- own-resource / delegated scope, if actually required.

Deny by default when no grant applies.

## Tenant isolation

For tenant-owned data:
- make tenant ownership explicit in the data model;
- include `tenant_id`/equivalent in tables whose rows belong to a tenant unless a stronger parent relationship makes the ownership equally enforceable;
- scope reads and writes server-side using authenticated/validated tenant context;
- never accept an arbitrary tenant identifier from the client as sufficient proof of access;
- validate membership and authorization before using tenant context;
- use tenant-aware unique constraints and indexes where uniqueness is tenant-local;
- design foreign keys/constraints so cross-tenant relationships cannot be created accidentally when practical;
- review background jobs, caches, object storage paths, search indexes, exports, logs, analytics, and queues for tenant leakage;
- never rely on obscurity of object IDs to prevent cross-tenant access.

For PostgreSQL or other DBs with row-level security, RLS may be used as defense in depth when appropriate, but application authorization still needs explicit, testable design. Do not adopt RLS automatically without evaluating operational/tooling complexity.

## Ownership and resource authorization

If authorization depends on resource ownership:
- persist ownership explicitly;
- define transfer rules;
- define behavior for deleted/deactivated owners;
- distinguish owner, creator, assignee, and tenant membership;
- verify resource belongs to the authenticated tenant before applying an ownership rule.

## Lifecycle

Define states and transitions when relevant:
- invited;
- pending;
- active;
- suspended;
- deactivated;
- removed.

Separate user/account state from tenant membership state where the product can support multiple tenants.
Role assignment/revocation and membership status changes should be auditable.

## Database integrity and performance

- enforce invariants with PK/FK/unique/check constraints where appropriate;
- use explicit migrations;
- add indexes based on actual authorization/query paths;
- consider composite indexes beginning with tenant/scope keys for tenant-scoped access patterns;
- avoid N+1 permission resolution;
- cache effective permissions only with a clear invalidation strategy;
- do not duplicate derived effective permissions into many rows without a justified consistency strategy;
- handle concurrent invitation/role/membership changes safely.

## API/backend rules

Every protected server operation should:
1. establish authenticated identity;
2. establish validated tenant/scope context when applicable;
3. load/derive authoritative membership and permissions;
4. authorize the action;
5. validate resource tenant/ownership;
6. perform the operation;
7. audit security-sensitive changes when required.

Use stable authorization error behavior without leaking sensitive existence information across tenants.

## Frontend/mobile rules

Clients may:
- hide/disable controls using effective permissions returned by the backend;
- tailor navigation and UX based on granted capabilities;
- cache non-sensitive permission metadata when safe.

Clients must not:
- be the only enforcement point;
- manufacture elevated roles/permissions;
- trust locally modified claims;
- assume a hidden button protects an API.

Mobile apps must follow the same model. Local secure storage can protect tokens, but cannot become the authorization source of truth.

## Auditability

Security-sensitive events should capture appropriate fields such as:
- actor;
- tenant/scope;
- action;
- target/resource;
- previous/new state when safe and useful;
- timestamp;
- request/correlation ID;
- source/channel;
- result.

Do not log passwords, tokens, private keys, or unnecessary sensitive data.

## Human Decision Gate

Escalate when the feature changes:
- role/permission model semantics;
- tenant isolation strategy;
- delegated admin model;
- system-vs-tenant scope;
- direct grants/denies;
- resource-level ACL approach;
- external identity provider;
- session/token revocation semantics;
- major security or compliance behavior.
