# PD-004 — Admin-Managed Metadata, Integrations and Runtime Configuration

- Status: Accepted for design; implementation not started
- Decision date: 2026-09-25
- Decision owner: Product owner
- Source: `docs/01-product/source-extensions/Sportapp_v6_Extension_01_Admin_Managed_Metadata_Integrations_Config.md`
- Feature: `FEAT-002-admin-managed-metadata-config`

## Decision

The private web admin is the primary management surface for safe product metadata, taxonomy, catalog classifications, integration registry/capabilities, source mappings, localization, feature visibility, bounded runtime configuration and their release histories.

All managed material uses stable immutable codes/IDs, typed definitions, versioned revisions and an explicit change-set lifecycle. Draft changes never reach applications. A publish is validated, atomic, audited, reversible and compatibility-aware. Display-name or mapping changes never silently reinterpret historical plans or source records.

Integration state is multi-dimensional: user visibility, new-connection permission, backend enablement, maintenance, support status and existing-connection behavior are separate. Admin configuration may reduce a verified capability but cannot invent provider/OS support, entitlement, permission or safety capability.

Admin-managed provider secrets follow ADR-009. Deployment roots, authentication/authorization enforcement, consent enforcement, database isolation constraints, cryptographic algorithms, signing/entitlement capabilities, arbitrary code/SQL and unbounded privileged URLs remain outside runtime configuration.

## Scope boundary

This is a delta to the v6 product and FEAT-001, not a rewrite. The repository currently has no product code, so the source document's code-inventory/migration instruction becomes the first future implementation gate: inspect the actual code once it exists, produce the hard-coded-to-managed migration matrix, and preserve existing identifiers/history. No inventory result is claimed today.

## Approved operational model

- Lifecycle: `DRAFT → VALIDATING → READY_TO_PUBLISH → ACTIVE → SUPERSEDED`, with `VALIDATION_FAILED` and audited rollback.
- `WRITE` and `PUBLISH` permissions are separate; publishing requires recent MFA/step-up, reason, diff preview and confirmation.
- iOS/backend consume only published, schema-versioned snapshots; iOS uses ETag/version cache, last-known-good fallback and bundled safe defaults.
- Config is small snapshot/delta data; catalog is versioned and paginated. Cache invalidation is version-keyed and stampede-safe.
- Hard delete is limited to unreferenced drafts; published/referenced records are deactivated, deprecated or replaced.
