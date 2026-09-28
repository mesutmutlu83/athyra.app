# Configuration

No application configuration exists yet. Configuration design must separate environments and keep secret values outside source control.

Required future configuration families include Cloudflare account/Worker/environment identifiers and compatibility dates, Apple/Google audiences/redirects, identity signing/session policy, support/transactional email, push, Neon Free/Hyperdrive/outbox/Workflow/storage and quota thresholds, encrypted backup target/retention, AI provider/model/budget, billing environments/product mappings, catalog source versions/hashes, consent/policy versions, supported client/API/catalog schemas, feature/kill switches, and observability endpoints.

Credentials must be referenced through an approved secret store. Mobile bundles and browser code must not contain server, billing, signing, or AI secrets.

The API and admin Workers projects use separate environment-variable/secret scopes. Preview deployments must use non-production identity keys, Neon branches, Workflows/R2 buckets, billing, AI and email resources. A support address is configuration; no placeholder address may be published as functional contact information.

## Runtime-administered settings

Under PD-004/ADR-010, the private admin panel manages validated, typed, versioned settings and metadata through draft/validate/diff/publish/rollback releases. Each definition specifies namespace, type, default, bounds/options, scopes, edit/publish permissions, reload/client compatibility and sensitivity. A generic untyped key-value editor is prohibited.

Examples include:

- active AI adapter/model per task, budget, timeout, output limit and feature/kill state;
- Ollama HTTPS base URL, model/capability mapping and opaque authentication-secret reference;
- SMTP host, port, TLS mode, username, From/Reply-To addresses and template selection;
- reviewed S3-compatible provider instance, endpoint, region, bucket and active-write selection;
- connection-test status and last successful verification metadata.

Supported deterministic scopes are global, environment, platform, app-version range, iOS-version range and only justified country/region or general rollout segment. Health-derived advertising/segmentation is prohibited. Precedence is server-defined and testable; admin cannot reorder it ad hoc.

Authentication/RBAC/consent enforcement, isolation constraints, cryptographic algorithms/root keys, HealthKit/App Store entitlements, provider capability ceilings, safety-critical unbounded limits, arbitrary code/SQL/prompts and privileged arbitrary URLs are not runtime-administered.

AI/SMTP/storage secrets are write-only and envelope-encrypted under ADR-009. The UI returns only a masked presence/version, never the secret value. Secret changes require owner permission, recent MFA/step-up, confirmation and audit. Runtime settings cannot add an unreviewed adapter, disable mandatory TLS, bypass recipient/consent policy or expose loopback, link-local, unsafe private-network or otherwise prohibited endpoints.
