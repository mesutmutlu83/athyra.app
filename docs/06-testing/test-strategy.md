# Test Strategy

No framework or runnable quality command exists yet. The accepted future stack is Vitest with Cloudflare Workers integration for API/domain tests, Playwright for admin browser E2E and XCTest for native iOS. Versions and commands are not invented until manifests/projects exist. The source brief supplies 220 acceptance scenarios, all currently `NOT_RUN`.

Required layers:

- Unit tests for policies, state machines, money/time arithmetic, schema validation, and deterministic planning guards.
- Contract tests for identity, health-source, AI, catalog, billing-provider, and event adapters.
- Integration tests for database constraints, migrations, outbox/jobs, consent revocation, authorization, idempotency, and reconciliation.
- Native iOS tests across approved OS/device branches, including physical iPhone 12/mini evidence for critical flows and performance.
- Browser E2E for admin invitation/MFA/RBAC, CRM/support, billing, export, CSRF/XSS, and revoked sessions.
- Real provider sandbox/application tests kept distinct from mocks and synthetic fixtures.
- Security/privacy negative tests and deletion/retention recovery tests.

The test-framework decision is accepted. `.codex/quality-gate.env` remains unconfigured until real commands exist; selecting tools does not constitute installed or passing test capability.
