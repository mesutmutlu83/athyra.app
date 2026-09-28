# ADR-006: Cloudflare Workers Deployment Topology

- Status: Accepted with Free-tier feasibility and legal release gates
- Date: 2026-09-25
- Decision owner: Product owner
- Supersedes: ADR-002
- Related feature(s): FEAT-001

## Context

The API and private CRM/admin must deploy as separate serverless applications from GitHub. The product owner selected Cloudflare Workers Free instead of Vercel. Neon PostgreSQL remains the durable relational store and R2 is the default object store.

## Decision

Use two independently deployable Cloudflare Workers projects in one repository:

- `api`: Hono/TypeScript Worker API;
- `admin`: React/Vite single-page private CRM/admin deployed with Workers static assets.

Production deploys originate from a protected GitHub branch after repository quality gates. Preview/test configuration is isolated from production. Use Neon Free in Frankfurt through Cloudflare Hyperdrive, which requires a benchmark before production.

Use R2 with EU jurisdiction as the default object store through the S3-compatible abstraction in ADR-008. Use a transactional Neon outbox plus Cloudflare Workflows for long-running imports, AI work, exports/deletion and reconciliation. Cloudflare Queues is optional later for bounded email/push fan-out; request-local background execution is not authoritative.

## Free-tier constraints

The initial design must fit documented Free limits and fail closed when quotas are exhausted. Limits are configuration/capacity gates, not product guarantees. Expensive SSR, password hashing, large transformations and unbounded orchestration must be benchmarked against Worker CPU limits. A paid-plan or topology change is required before workload exceeds verified headroom.

## Residency boundary

Neon Frankfurt and R2 EU jurisdiction provide EU-primary persistent storage. The product owner accepts that Workers Free may execute on Cloudflare's global edge, subject to explicit disclosure, DPA/subprocessor review and an approved KVKK international-transfer mechanism. Placement near Frankfurt is only a latency preference. The system must not claim EU-only processing.

## Consequences

- NestJS and Next.js are superseded by Hono for the API and React/Vite SPA for the admin application.
- API handlers remain stateless, bounded and idempotent.
- In-memory schedulers, local-disk persistence and always-running process assumptions are prohibited.
- Database migrations are explicit release steps and are not run concurrently by Workers.
- iOS clients require backward-compatible API contracts independent of Worker deployments.

## Rollback

Worker rollback does not undo schema changes, messages or external side effects. Use additive migrations, idempotency, versioned messages and feature/kill switches.
