# Shared Application Foundations

This document is the registry of cross-cutting application capabilities. It prevents each feature/team/agent from inventing incompatible versions of the same subsystem.

Only mark a capability as adopted after inspecting the real repository.

| Foundation | Status | Canonical implementation | Owner | Notes |
|---|---|---|---|---|
| Users / identity mapping | not assessed | | | |
| Tenants / organizations / workspaces | not assessed | | | |
| Memberships | not assessed | | | |
| RBAC / permissions | designed; not implemented | `docs/04-engineering/identity-access-tenancy.md` | | FEAT-002 separates read/write/publish and never grants health access by admin role alone |
| Invitations | not assessed | | | |
| Audit log | designed; not implemented | ADR-010 / FEAT-002 | | Immutable release/change audit without secrets or health payloads |
| Settings/preferences | designed; not implemented | ADR-010 / `configuration.md` | | Typed definitions, revisions, releases and deterministic scopes |
| Feature flags | designed; not implemented | ADR-010 / FEAT-002 | | Visibility/rollout only; never authorization |
| Notifications | not assessed | | | |
| Files/media | not assessed | | | |
| Localization/timezone | designed; not implemented | FEAT-002 metadata/localization | | Stable codes with revisioned display metadata; Istanbul commercial quota boundary |
| API errors/pagination/idempotency | not assessed | | | |
| Rate limiting / abuse controls | not assessed | | | |
| Background jobs | not assessed | | | |
| Observability | not assessed | | | |
| Cache/search/indexing | designed; not implemented | ADR-010 | | Version-keyed snapshots, ETag, paged catalog and stampede controls |

## Rule

When a feature needs one of these concerns:
1. inspect the canonical implementation first;
2. reuse or extend it;
3. create a new parallel mechanism only with a documented reason;
4. record material architecture changes in an ADR.
