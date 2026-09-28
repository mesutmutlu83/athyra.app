---
name: common-application-foundations
description: "Apply consistent cross-cutting foundations used by production SaaS, web, API, and mobile applications: identity, tenancy, settings, audit, notifications, files, localization, pagination, idempotency, lifecycle metadata, feature flags, errors, observability, configuration, background jobs, and operational hygiene."
---

Use this skill to check whether a feature should reuse an existing shared application capability instead of inventing a feature-local implementation.

These are defaults, not a command to build every subsystem. Implement only what the product needs. The rule is: when a cross-cutting concern exists, solve it consistently and centrally.

## Common foundations registry

Evaluate applicability of:

1. Identity and access
   - users/accounts;
   - authentication identity mapping;
   - organizations/tenants/workspaces;
   - memberships;
   - roles/permissions;
   - invitations;
   - service accounts/API keys when needed.

2. Audit and history
   - immutable/append-oriented audit events for security/business-significant changes;
   - actor, tenant, action, target, timestamp, correlation context;
   - domain history/versioning only when product requirements need it.

3. Configuration and settings
   - application/environment configuration;
   - tenant-level settings;
   - user preferences;
   - explicit precedence rules such as system -> tenant -> user;
   - validated defaults;
   - no secrets in ordinary settings tables or client code.

4. Feature flags
   - separate rollout/experimentation flags from authorization permissions;
   - define ownership and retirement/removal;
   - do not use feature flags as a substitute for security authorization.

5. Notifications
   - reusable notification event/model;
   - channel preferences;
   - delivery status/retry where required;
   - localization/template strategy;
   - idempotent delivery handling where duplicates are possible.

6. Files/media
   - metadata in DB when the product needs ownership/state;
   - binary/object content in an appropriate object/file store unless the architecture intentionally says otherwise;
   - tenant ownership;
   - access checks;
   - content type/size validation;
   - malware/security handling where relevant;
   - retention/deletion behavior.

7. Localization/time
   - stable localization keys rather than scattered hard-coded UI strings when localization is in scope;
   - store timestamps in an unambiguous canonical representation;
   - convert/display in user/product timezone at presentation boundaries;
   - do not mix locale-specific formatting into persistent domain values.

8. API behavior
   - consistent error envelope/semantics;
   - validation;
   - pagination for unbounded collections;
   - filtering/sorting contracts;
   - idempotency for retryable create/payment/side-effect endpoints when relevant;
   - request/correlation IDs;
   - rate limiting/abuse protection where exposed risk warrants it;
   - versioning/backward compatibility for public contracts.

9. Data lifecycle
   - created/updated timestamps when useful;
   - created_by/updated_by when the domain needs actor traceability;
   - explicit status/lifecycle fields rather than ambiguous booleans when multiple states exist;
   - soft delete only when recovery/audit/product requirements justify it;
   - retention and hard-delete/anonymization rules for sensitive data;
   - migrations for every persistent schema change.

10. Background work
    - explicit job ownership;
    - idempotency;
    - bounded retries/backoff;
    - poison/dead-letter handling where needed;
    - visibility/metrics for failed jobs;
    - tenant context propagated safely.

11. Observability
    - structured logs;
    - metrics;
    - traces/correlation IDs where useful;
    - no secrets or unnecessary personal data in telemetry;
    - tenant identifiers only when safe and operationally justified.

12. Search/cache
    - treat caches and indexes as derived state unless explicitly designed otherwise;
    - include tenant boundary in cache/index keys;
    - define invalidation/rebuild behavior;
    - never let a shared cache bypass authorization.

## Reuse over duplication

Before creating feature-local infrastructure, search the repository for an existing shared implementation.
Do not create:
- a second user model;
- another role/permission system;
- feature-specific audit tables that conflict with a shared audit model;
- separate ad-hoc settings mechanisms;
- inconsistent pagination/error formats;
- duplicate notification engines;
without a documented reason.

## Security and data rules

Use `identity-access-multitenancy` whenever identity, roles, permissions, tenants, ownership, invitations, or access control are involved.
Use database constraints for durable invariants.
Use server-side enforcement for authorization.
Keep configurable behavior out of hard-coded application logic.

## Mobile/web consistency

Shared business rules should normally live behind backend/domain APIs, not be independently reimplemented in web, Android, and iOS.
Clients may implement platform-specific presentation, offline/cache behavior, and device capabilities, but server-side domain/security rules remain canonical.

## Human Decision Gate

Escalate new cross-cutting platform choices that materially affect many features, such as:
- adopting a new identity provider;
- introducing a new feature-flag vendor;
- changing audit/retention architecture;
- adding a new notification platform;
- replacing file/object storage;
- changing API versioning/error conventions;
- introducing a shared cache/queue/search platform.
