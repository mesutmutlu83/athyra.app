# PD-001 — Bootstrap Decisions and Follow-up Gates

- Status: Accepted with listed follow-up gates
- Decision date: 2026-09-25
- Decision owner: Product owner
- Source: `docs/01-product/project-brief.md`

The imported source brief remains the requirements inventory. The explicit decisions below resolve or narrow its open alternatives. Where a decision changes the original P0 proposal, this record takes precedence until the source brief is formally revised.

| ID | Accepted decision | Consequence | Remaining Human Decision Gate |
|---|---|---|---|
| IOS-SUPPORT-001 | Minimum deployment target is iOS 15; supported device intent remains iPhone 12 family and later | iOS 14 is not a supported release target; every dependency and physical-device matrix must preserve iOS 15 compatibility | Final Xcode/SDK/dependency matrix and signed archive/device evidence before release |
| BILLING-001 | Permanent Free tier plus Pro at TRY 249.99/month or TRY 1,999.99/year; 7-day annual trial; Turkey-only initial beta; StoreKit only; billing grace enabled; upgrade immediate/downgrade next renewal; Family Sharing and admin promotions off; failed/cancelled AI work does not consume quota; expiry never destructively deletes Pro data | Account, membership, transaction and entitlement remain separate; conflicting account restore/transfer is support-reviewed and never automatic | Seller entity, tax/invoice/legal/App Store approval, product IDs and exact grace-period configuration |
| ARCH-001 | API and private CRM/admin are separate Cloudflare Workers Free applications deployed from GitHub; API uses Hono, admin uses React/Vite SPA; Neon PostgreSQL Free in Frankfurt is the source of truth; R2 EU is the default object store; Neon outbox plus Cloudflare Workflows handles durable background work | Vercel is no longer a target. API/admin deploy independently; persistent data is EU-primary; Queues may be added later for bounded fan-out | Free-tier feasibility/capacity and recovery tests; automated 35-day backup is explicitly deferred but blocks production data |
| AUTH-001 | Application-owned identity data and sessions in Neon; Hono + Better Auth + Drizzle is the accepted first implementation candidate; no paid CIAM dependency. Email/password plus native Apple/Google token exchange; invitation-only admin MFA | Authentication uses reviewed libraries/protocols and server-side token verification; application DB owns users, mappings, roles and permissions | Worker Free CPU feasibility spike, Better Auth native-flow/security validation, mail recovery and admin MFA configuration |
| PRIVACY-001 | EU-primary persistent storage plus disclosed Cloudflare global edge processing under approved cross-border safeguards; approved retention matrix and separate consent for source access, Sportapp processing, AI disclosure, coach sharing and marketing | Task-required raw health records may be sent to an approved AI only under separate explicit consent and bounded selection; no EU-only compute claim; indefinite retention is prohibited | Legal basis, KVKK transfer mechanism/notification, controller/processor roles, DPA/subprocessors and legal approval |
| AI-001 | Initial release uses an owner-operated Ollama endpoint configured by an authorized owner in the web admin; model and bounded runtime settings are selected there behind the provider-neutral gateway | The endpoint must be Worker-reachable HTTPS, security-validated and consent-policy-bound; `localhost`/LAN discovery and end-user BYOK are out of scope; no silent fallback | Concrete Ollama host/model/capacity/region and credentials may be supplied later before AI integration testing |
| ENGINEERING-001 | Test stack target is Vitest with Cloudflare Workers integration for API/domain tests, Playwright for admin browser E2E and XCTest for native iOS | Versions and runnable commands are added only when manifests/projects exist; source acceptance IDs remain canonical | Version pinning and real command evidence during implementation |
| SECRETS-001 | Runtime-administered AI/SMTP/S3 secrets use envelope encryption: ciphertext and metadata in Neon, environment root key in Cloudflare Worker Secret | Admin UI is write-only/masked; rotations, decrypt authorization and audit are server-side; no plaintext in DB/logs/client | Key provisioning/rotation/recovery test before real credentials |
| CATALOG-001 | Broad catalog recognition with staged automation; automated planning is enabled only for versioned sport packages that have named expert review | Unreviewed catalog items may be recognized/displayed but cannot make an automated-coaching maturity claim | Source versions/licenses, content rights, named expert owners, initial automated package release matrix |
| OPS-001 | Lean beta: support is received through a Gmail/Google Workspace mailbox and public support page; SMTP settings are administered through the private admin panel; no public SLA and no 24/7 on-call promise | Apple release metadata must provide a working support URL with real contact information; email secrets are write-only/vault-backed; outages are handled best-effort | Exact support address/domain/owner, Workspace account and relay authorization, working hours, escalation contact, backup targets and incident process |

## Accepted privacy retention targets

These are accepted product retention targets, subject to mandatory legal/tax exceptions and final legal review:

- Free raw imported health/activity detail: rolling 30 days;
- Free derived monthly summaries: rolling 12 months;
- Pro raw imported health/activity detail: rolling 12 months;
- accepted plans: account lifetime or earlier account deletion;
- transient AI prompt payload: no intentional application persistence;
- AI output and provenance: plan lifetime;
- security logs without sensitive payload: 90 days;
- privileged admin audit: 2 years;
- backups: 35 days;
- CRM/support records: delete or anonymize after 24 months of inactivity unless an approved obligation applies;
- generated exports: 24 hours;
- account deletion workflow: complete within 30 days, except isolated mandatory records;
- financial records: only the minimum period approved by legal/tax advisers;
- deletion from backup generations occurs through normal backup expiry, within 35 days.

## Decision boundaries

- Apple requires a support URL with actual contact information for App Store metadata; it does not create a contractual uptime SLA or mandate a 24/7 on-call team.
- Cloudflare Workers Free is the selected initial deployment target, not the durable system of record. Its quotas are launch constraints, not a production-capacity guarantee.
- Neon Free in Frankfurt and R2 EU jurisdiction keep primary persistent storage in the EU. The product owner accepts that Workers Free may process requests on Cloudflare's global edge, subject to explicit notices, processor contracts and an approved KVKK international-transfer mechanism. The product must not claim EU-only compute residency.
- Neon Free's built-in restore history does not satisfy the accepted 35-day backup target. Backup implementation is deferred during documentation/development, so real production health data is prohibited until a tested encrypted automated backup/restore path is approved.
- Changing the active S3-compatible object-store provider affects new writes only. Existing objects keep their original provider/bucket/key reference until an explicit verified migration completes.
- Initial Ollama support means a Worker-reachable, operator-approved HTTPS endpoint behind the AI gateway. An Ollama process reachable only as `localhost` or on an end user's LAN is not part of the release topology.
- Product code must not begin until the relevant provider/account and privacy follow-up gates for that slice are approved.
