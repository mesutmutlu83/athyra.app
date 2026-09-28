# Integrations

ADR-010 makes this list the canonical initial inventory for a future database-backed Integration Registry. Runtime visibility, new-connection permission, backend enablement, maintenance, support status, existing-connection behavior, capability evidence and source mappings are revisioned independently; admin settings cannot exceed adapter/provider/OS capability ceilings.

| Integration | P0 purpose | Status |
|---|---|---|
| Apple Health / HealthKit | Native, read-only import of supported existing records | Required; not implemented or tested |
| Application-owned identity | Hono + Better Auth + Drizzle candidate with Neon-backed credentials, sessions, recovery, provider mappings and admin MFA | Selected candidate; Worker/native/security feasibility pending |
| Apple identity | Native Apple flow with server-side token verification and durable subject mapping | Required; account/client configuration deferred |
| Google identity | Native Google flow with server-side token verification and durable subject mapping | Required; account/client configuration deferred |
| Owner-operated Ollama | Initial planning/adaptation/chat provider through an admin-configured Worker-reachable HTTPS endpoint and validated Ollama adapter | Selected; concrete host/model/capacity supplied later |
| Additional AI adapters | Later operator-approved providers behind the same gateway | Future; no initial end-user BYOK/custom URL |
| App Store billing | Free tier plus TRY 249.99 monthly / TRY 1,999.99 annual Pro and 7-day annual trial through StoreKit | Required before paid launch; product IDs/seller/legal approval pending |
| Cloudflare R2 / S3-compatible storage | EU-default private object storage with admin-configurable reviewed provider instances | Required; credentials/migration/recovery tests pending |
| Cloudflare Workflows | Transactional Neon-outbox-driven multi-step AI/import/export/deletion/reconciliation execution | Selected; implementation and quota/recovery evidence pending |
| Gmail / Google Workspace SMTP | Receive support and send approved transactional messages through admin-managed SMTP configuration | Required before App Store submission; address/domain/relay setup deferred |
| APNs | Product/service push notifications | Required; account/key configuration deferred |
| Garmin FIT/source vocabularies | Versioned catalog ingestion and mapping | Required source decision/rights review |

Google/Huawei-to-Apple-Health bridge behavior must be tested as an observed route, not represented as direct private-database or device access. Samsung and other unverified routes remain blocked or later scope.
