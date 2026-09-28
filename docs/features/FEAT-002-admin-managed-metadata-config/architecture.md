# FEAT-002 Architecture

Canonical decision: `docs/03-architecture/adrs/ADR-010-versioned-admin-managed-configuration.md`.

## Components

- Admin React/Vite modules for metadata, content, integrations, config/flags and release management.
- Hono admin APIs with DB-backed permissions, optimistic concurrency, validation, audit and outbox.
- Neon revision/release entities integrated with existing domain catalog/config concepts.
- Cloudflare Workflows for large validation, reclassification and cache fan-out jobs.
- Filtered public/app config and catalog APIs with ETag/version compatibility.
- ADR-009 runtime secret service for provider credential references.

## Data flow

Draft edits → change set → validation/evidence checks → publish authorization/step-up → atomic release activation + audit/outbox → version-keyed cache invalidation → backend/iOS published snapshot refresh.

## Migration

Implementation begins with an actual inventory of enums, lists, switches, labels, provider booleans and capability assumptions. Seed managed records with stable mappings, preserve referenced IDs, compare baseline behavior, then move readers incrementally. No current migration is claimed because no product code/schema exists.

## Compatibility

Releases carry schema/min-app compatibility. Unknown non-critical fields are ignored; incompatible critical schema hides the feature or produces a controlled update requirement. Historical artifacts retain snapshots and version references.

## Reliability

Publication is atomic and idempotent. Validators and asynchronous jobs are resumable. The current active release remains available during failed validation/publish. Cache keys include release version; large catalog delivery is paged/delta-aware.
