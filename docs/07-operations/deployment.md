# Deployment

No deployable artifacts or CI/CD exist. ADR-006 selects two Cloudflare Workers Free projects connected to GitHub: a Hono/TypeScript API and React/Vite private CRM/admin SPA. Pull requests receive isolated preview deployments; the protected production branch may deploy only after repository quality gates and required review. Unaffected-project build skipping may be configured without weakening checks.

Delivery separately versions API/durable workflows, admin web, catalog/policy data, and the signed iOS archive; preserves backward compatibility for supported clients; runs additive migrations as an explicit controlled step; verifies health/readiness and Free-tier headroom; and provides kill switches for AI generation, imports, admin writes, and new sales. Long work uses the approved durable workflow and is not continued as untracked request-local background work.

Rollback must stop unsafe new work without deleting verified financial events, consent/audit history, or published plan history.

External backup implementation is intentionally deferred for the current documentation/development phase. No real production health data may be admitted until an automated job encrypts a portable PostgreSQL backup, writes it to R2 EU or another approved EU store, applies the accepted 35-day retention, verifies checksums and passes an isolated restore drill. Built-in Neon restore history and database branches do not replace this control.
