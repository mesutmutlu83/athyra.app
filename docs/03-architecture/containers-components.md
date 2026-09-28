# Containers / Components

The following approved logical/deployment decomposition is not yet implemented:

| Unit | Responsibilities |
|---|---|
| Native iOS app | Athlete and coach UI, native identity callbacks, read-only HealthKit adapter, protected cache/outbox, permission UX |
| Admin web — Cloudflare Workers project | React/Vite SPA for private staff invitation/MFA, scoped users, CRM, membership/billing operations, versioned metadata/configuration/integration management, release review, reports and audit |
| API — Cloudflare Workers project | Hono/TypeScript identity/session, RBAC, profiles, plans, consent, catalog, entitlements, CRM, AI gateway, configuration validation/publishing and policy enforcement |
| Durable workflows | Transactional Neon outbox plus Cloudflare Workflows for import normalization, AI jobs, catalog import/review, reconciliation and exports/deletion; Queues optional later for bounded notification fan-out |
| Managed PostgreSQL | Neon Free Frankfurt; durable application truth, constraints, versions, audit references, outbox and idempotency state |
| Runtime secret vault | Ollama/SMTP/S3 ciphertext in Neon with environment root key in Cloudflare Worker Secret under ADR-009; identity/billing/infrastructure deployment secrets remain environment-scoped |
| Object/artifact storage | R2 EU by default through a configurable S3-compatible adapter; authorized exports/evidence/documents with short-lived access |

ADR-006 fixes Cloudflare Workers Free, Hono, React/Vite and Workflows/outbox topology; ADR-005 fixes Neon Free Frankfurt. ADR-008 fixes configurable R2/S3 storage, ADR-009 fixes runtime secret encryption and ADR-010 fixes the versioned admin-managed configuration foundation. Free-tier capacity evidence, secret recovery validation, deferred 35-day backup/restore and legal transfer approval remain release gates.
