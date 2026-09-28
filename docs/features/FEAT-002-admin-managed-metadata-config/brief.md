# FEAT-002 — Admin-Managed Metadata, Integrations and Configuration

- Status: discovery / design accepted
- Product owner: Product owner
- Source: `docs/01-product/source-extensions/Sportapp_v6_Extension_01_Admin_Managed_Metadata_Integrations_Config.md`

## Problem

User-visible taxonomy, catalog classification, integration state/capability and safe product parameters must not be scattered across hard-coded lists or opaque deployment configuration. Uncontrolled remote configuration would, however, create security, safety, compatibility and historical-data risks.

## Outcome

Authorized staff manage the safe subset through the existing private admin using versioned drafts, validation, diff, publish and rollback. Published clients/backend consume deterministic compatible snapshots; historical plans, activities and mappings preserve their original meaning.

## In scope

- Sport/content taxonomy, relations, aliases, localization, source mappings and review lifecycle.
- Integration registry, independent runtime states, capability matrix and verification evidence.
- Typed bounded product configuration, feature flags and environment/version scopes.
- Release management, RBAC separation, audit, public snapshot/cache/fallback contracts.
- Existing provider settings such as Ollama, SMTP and S3 via ADR-009 secret references.

## Out of scope

- Source-code editing, scripts, arbitrary SQL, unbounded rules/prompts or arbitrary privileged URLs.
- Admin bypass of auth/RBAC, consent, safety validation, health/platform entitlement, StoreKit authority, crypto or DB constraints.
- Claiming unsupported provider capabilities through toggles.
- Product-code implementation in the current documentation phase.

## Constraints

This feature extends v6/FEAT-001 and must preserve IDs, history, accepted plans, raw source provenance, user/coach/admin isolation and existing commercial/privacy decisions.
