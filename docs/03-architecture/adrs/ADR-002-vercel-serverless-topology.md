# ADR-002: Two-Project Vercel Serverless Topology

- Status: Superseded by ADR-006
- Date: 2026-09-25
- Decision owners: Product owner
- Related feature(s): FEAT-001

## Context

The initial product requires a private CRM/admin web application and an API used by the native iPhone application and admin. The product owner will deploy both through Vercel using GitHub pushes.

## Constraints

- API and admin must be independently deployable.
- PostgreSQL is the durable source of truth.
- Health, identity, financial and CRM data require approved regional processing and strict authorization.
- AI generation, imports, billing reconciliation, export/deletion and notifications can outlive an HTTP request.

## Options considered

- Two Vercel projects from one GitHub repository: accepted.
- One combined Vercel project: rejected because independent deployment and trust boundaries are desired.
- GCP container topology: rejected as the initial deployment target; it remains a future migration option.

## Decision

Use a monorepo with two independently configured Vercel projects:

- `api`: NestJS/TypeScript deployed as Vercel Functions;
- `admin`: Next.js/TypeScript private CRM/admin application.

GitHub pull requests create preview deployments. The protected production branch triggers production deployment only after repository quality gates and required review pass. Each project has separate environment variables, domains, secrets and deployment protection.

Use Neon PostgreSQL through a serverless-safe pooled connection. Use a durable asynchronous queue/workflow for background work; queue messages contain identifiers and minimal metadata, not raw health payloads. Exact workflow, object-storage and final regional settings remain follow-up decisions.

## Consequences

- API handlers are stateless, idempotent and bounded by function execution limits.
- WebSockets, in-memory schedulers, local disk persistence and always-running worker assumptions are prohibited.
- Schema migrations are an explicit release step and are not run concurrently by every function instance.
- Preview deployments must never connect to production data, identity, billing or AI credentials.
- Native iOS releases remain separate from Vercel deployments and require backward-compatible API contracts.

## Security / data / operations impact

Admin and API origins use explicit CORS/CSRF/session policies. CIAM callbacks, StoreKit notifications, workflow consumers and scheduled endpoints require independent authentication and replay protection. Neon/Vercel regions, DPA/subprocessors, backup/PITR, connection limits, egress and audit export must be approved before production.

## Rollback or migration considerations

Vercel deployment rollback does not roll back database migrations or external side effects. Use additive migrations, versioned events and kill switches. Core domain logic must avoid unnecessary Vercel-specific coupling so a future container worker or API migration remains possible.
