# ADR-010: Versioned Admin-Managed Metadata and Configuration

- Status: Accepted for design; not implemented
- Date: 2026-09-25
- Decision owner: Product owner
- Related feature(s): FEAT-002

## Context

Sportapp needs to add and revise taxonomy, catalog metadata, integration visibility/capabilities, mappings, localization, feature flags and bounded product parameters without requiring an application release for every safe change. These controls must not mutate historical meaning or bypass platform, security, consent or safety constraints.

## Decision

Build one database-backed configuration/catalog foundation rather than parallel per-feature stores:

- typed `ConfigDefinition` records define namespace, data type, default, validated bounds/options, scopes, edit roles and reload compatibility;
- revisions are grouped into `AdminChangeSet` and immutable release records;
- metadata/catalog entities retain stable immutable codes and versioned display/relationship revisions;
- integration definitions retain stable provider codes, revisioned capabilities/mappings and verification evidence;
- feature flags use the same release/audit model but never replace authorization checks;
- provider secrets are opaque ADR-009 references, not config values.

Publish validation checks referential integrity, duplicate codes, localization requirements, orphan relationships, provider capability ceilings, safe ranges, secret leakage, minimum schema/app compatibility and historical-plan compatibility. Publish atomically activates a release; rollback activates a prior valid release without deleting history.

## Capability authority

Adapter code and verified evidence define each provider/OS capability ceiling. Admin settings can hide, pause, restrict or mark maintenance but cannot expand beyond that ceiling. HealthKit entitlements, iOS sandbox behavior, StoreKit authority, auth/RBAC, consent, crypto and DB isolation remain code/platform policy.

Integration runtime state separates:

- `is_visible_to_user`;
- `is_new_connection_allowed`;
- `is_enabled`;
- `maintenance_mode`;
- `support_status`;
- `existing_connections_behavior` (`KEEP_RUNNING`, `READ_ONLY_EXISTING`, `PAUSE_SYNC`, `REQUIRE_REAUTH`, `DISABLE_ALL`).

## Client consumption

The API and decision engine resolve a deterministic published configuration snapshot for environment, platform, app/iOS version and only justified region/rollout scopes. Health-derived advertising/segmentation is prohibited. Decision records persist the material config/catalog/mapping versions used.

iOS receives filtered public snapshots only, caches by ETag/version, ignores unknown non-critical fields and uses last-known-good then bundled safe defaults. Draft, admin-only, secret, internal capability evidence and privileged fields never enter public payloads.

## Consequences

- A new sport/catalog classification should normally require data/config publication rather than DB migration, but new executable domain behavior may still require code.
- Mapping changes apply prospectively. Historical reclassification is a separate preview/diff/audited job and never rewrites raw source records.
- Published/referenced data is deprecated or superseded, not hard-deleted.
- Cache invalidation uses release-version keys; clients do not stampede-download the full catalog after publication.
- The first implementation stage must inventory actual hard-coded enums/lists/provider assumptions; no such inventory exists because no product code exists yet.
