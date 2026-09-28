# ADR-005: Neon PostgreSQL as Durable Data Store

- Status: Accepted — Free plan; backup deferred and production-blocking
- Date: 2026-09-25
- Decision owners: Product owner
- Related feature(s): FEAT-001

## Context

The two Cloudflare Workers applications require one relational source of truth for identity mappings, authorization, consent, plans, catalog versions, CRM, membership, financial evidence, workflow state and audit references.

## Decision

Use Neon PostgreSQL Free initially. Cloudflare Workers use Hyperdrive as the selected serverless-safe connection layer, subject to benchmark. Schema migrations and administrative maintenance use separately scoped credentials. Production, staging and preview data are isolated. Preview deployments use disposable Neon branches or dedicated non-production branches and never receive production data.

Frankfurt (`eu-central-1`) is the selected production database region. This is a persistent-storage decision and does not make Cloudflare Workers Free EU-only compute.

## Consequences

- Connection pooling, bounded transaction duration and serverless concurrency limits are mandatory.
- Database credentials are environment-scoped and never exposed to iOS/browser clients.
- Application authorization, foreign keys, uniqueness, idempotency and financial/consent invariants remain enforced in PostgreSQL.
- Free-plan storage, compute, egress, branch and restore-history consumption must be monitored with warning/stop thresholds; exceeding verified headroom triggers a paid-plan or topology decision before service degradation.
- Neon Free restore history does not meet the accepted 35-day backup target. Backup work is intentionally deferred during documentation/development. A separate encrypted automated backup to R2 EU or another approved EU store, plus restore drills, remains mandatory before any real production health data.

## Security / data / operations impact

Health and other restricted columns require strict role access, minimization and log/analytics exclusion. Neon region, DPA, subprocessors, backup location/retention and privileged access must be included in the privacy review.

## Rollback or migration considerations

Use standard PostgreSQL features where practical, additive migrations and portable backups. Neon branching and short restore history are not substitutes for 35-day backup/restore tests.
