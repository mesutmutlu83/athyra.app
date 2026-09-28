# Environments

The approved topology uses separate API and admin Cloudflare Workers projects. Each must separate local/development, preview/test, provider sandbox/staging, and production configuration. Identity keys/audiences/redirects, billing events/products, AI credentials/budgets, Neon/Hyperdrive, Workflows/Queues, R2/S3 providers, support/transactional email, push, and observability are environment-bound. Preview and sandbox environments must never reach production health/CRM data or affect production entitlements/reporting.

Cloudflare Workers Free, Hono, React/Vite, Neon Free Frankfurt, Hyperdrive, Neon outbox + Workflows and R2 EU are selected initial targets. Global Worker processing is accepted subject to approved notices/contracts/KVKK transfer safeguards. Free-tier capacity, external 35-day backup/restore, secrets and legal evidence remain release gates under `PD-001`.
