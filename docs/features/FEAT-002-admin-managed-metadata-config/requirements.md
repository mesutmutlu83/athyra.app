# FEAT-002 Requirements

## Functional requirements

- `AMC-001` Managed entities use immutable stable IDs/codes and versioned display/relationship metadata.
- `AMC-002` Sports, families, variants, training methods, session purposes, content types, body regions, muscle groups, movement patterns, equipment, levels, aliases and localization are managed through one catalog foundation.
- `AMC-003` Content records support review, activation, deprecation/replacement, manual/automatic prescription eligibility, AI visibility, source/rights and safety references.
- `AMC-004` Relations and source-to-canonical mappings are versioned; new mappings are prospective and never mutate raw source records.
- `AMC-005` Integration Registry exposes definition, environment/platform/mode, visibility, connectability, backend enablement, maintenance, support state, existing-connection behavior and verification history separately.
- `AMC-006` Capability matrix records source type, canonical metric, direction, availability/freshness, permission, AI/coach eligibility, normalization version and evidence; admin cannot exceed verified adapter/provider ceilings.
- `AMC-007` Product configuration definitions are typed, bounded, scoped, documented and role-controlled; unknown arbitrary keys are rejected.
- `AMC-008` Feature flags support bounded environment/version/optional rollout scopes, owner, reason, dates, audit and rollback; flags never authorize protected operations.
- `AMC-009` Every metadata/config/integration change uses an audited change set and `DRAFT → VALIDATE → READY → PUBLISH → ACTIVE/SUPERSEDE/ROLLBACK` lifecycle.
- `AMC-010` Validation blocks referential, duplicate-code, localization, orphan, unsafe range, unsupported capability, compatibility, migration and secret-leak failures.
- `AMC-011` Published records retain minimum app/schema compatibility and whether an update is required.
- `AMC-012` iOS/backend consume only published filtered snapshots; ETag/version, last-known-good and bundled safe fallback behavior is deterministic.
- `AMC-013` Plans/decision records persist material config/catalog/mapping versions and content snapshots.
- `AMC-014` Admin settings for Ollama, SMTP, S3, identity-provider mapping, APNs metadata, StoreKit mappings and other supported integrations use per-provider schemas and ADR-009 secret references.
- `AMC-015` Publishing invalidates version-keyed caches without forcing an immediate full-catalog download by every client.
- `AMC-016` Published/referenced records cannot be hard-deleted; deactivate, deprecate, withdraw or replace is used.
- `AMC-017` Historical reclassification is a separate preview/diff/audited job requiring explicit authorization.
- `AMC-018` Integration verification uses synthetic/provider health checks where possible and never exposes user health payloads to staff.
- `AMC-019` Actual code inventory and hard-coded-to-managed migration matrix are mandatory before implementation migration; current status is not assessed because no product code exists.

## Actors and authorization

| Actor | Allowed capability | Explicit denial |
|---|---|---|
| Metadata reader | View published/draft metadata allowed by scope | Write, publish, secret read |
| Metadata editor | Create/edit drafts and mappings | Publish, secret read, health access |
| Integration editor | Edit provider drafts, test permitted connections | Publish, expand verified ceiling, secret read |
| Config editor | Edit typed bounded draft settings/flags | Publish, policy/RBAC bypass |
| Publisher | Validate/diff/publish/rollback with step-up and reason | Secret plaintext, health access by role alone |
| AI config owner | Configure Ollama settings and replace credential | Read credential after save, arbitrary unsafe endpoint |
| CRM/support/finance staff | Existing scoped functions only | Metadata/config/integration publish unless separately granted |

Permissions include separate `READ`, `WRITE` and `PUBLISH` capabilities for metadata, integrations and config, plus `ADMIN_AI_CONFIG` and `ADMIN_AUDIT_READ`.

## Preserve invariants

- `PRESERVE-001` Existing v6 identity, consent, plan/adaptation, coach, billing, CRM and catalog behavior is not reimplemented or silently changed.
- `PRESERVE-002` Display/mapping changes do not rewrite historical meaning, snapshots or source provenance.
- `PRESERVE-003` Admin roles never imply health, coach-private-note or secret plaintext access.
- `PRESERVE-004` Draft or invalid releases never reach production clients/engines.

## Non-functional requirements

- WCAG 2.2 AA admin experience, keyboard-operable grids/forms/diffs and accessible validation summaries.
- Optimistic concurrency/version conflict handling for simultaneous editors.
- Paginated/filterable catalogs, bounded bulk operations and asynchronous validation where necessary.
- Immutable audit contains actor, time, environment, object, reason, before/after diff reference, change set and trace; no health payload or secret.
- Fail closed for policy/capability/security checks; fail safely to last-known-good published config for availability.

## Open implementation evidence

No product source/schema exists. Exact physical tables, endpoints, framework versions, current hard-coded inventory and migration/backfill plan remain implementation evidence, not product decisions.
