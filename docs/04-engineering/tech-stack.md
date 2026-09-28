# Tech Stack

Bootstrap found no application source, manifests, lockfiles, build files, CI workflows, or test configuration. The technologies below are approved targets from `PD-001` and the linked ADRs; they are not implementation evidence and versions remain unset until manifests/toolchains are created.

| Area | Technology | Version | Evidence / manifest | Notes |
|---|---|---:|---|---|
| Admin web | React/Vite/TypeScript on Cloudflare Workers static assets | Versions unpinned | ADR-006; no manifest | SPA selected to conserve Free CPU |
| Android | Out of P0 scope | — | Product brief | Separate approval required |
| iOS | Native Swift/SwiftUI, iOS 15+ | Unpinned | ADR-001; no Xcode project | iPhone athlete + coach; iPhone 12 family and later |
| Cross-platform mobile | Not selected | — | Product brief | Do not substitute for native iOS without approval |
| Backend | Hono/TypeScript on Cloudflare Workers | Versions unpinned | ADR-006; no manifest | Framework selected; Free CPU feasibility pending |
| Database | Neon PostgreSQL Free via Hyperdrive | PostgreSQL version unpinned | ADR-005; no schema | Frankfurt selected; capacity benchmark and external 35-day backup pending |
| API/domain test | Vitest + Cloudflare Workers test integration | Versions unpinned | Accepted target; no manifest/config | Install and commands deferred until implementation |
| Admin E2E | Playwright | Version unpinned | Accepted target; no manifest/config | Browser matrix configured during implementation |
| iOS test | XCTest | Xcode version unpinned | Accepted target; no Xcode project | Simulator plus required physical-device evidence |
| Build/CI | Not installed | — | No build/CI files | Quality commands cannot yet be configured |
| Runtime | Cloudflare Workers runtime | Compatibility date unpinned | ADR-006; no manifest | Node compatibility is not assumed; pin compatibility date at implementation |
| Identity | Better Auth + Drizzle candidate with application-owned Neon identity/sessions | Versions unpinned | ADR-007; no manifest | Security/native-flow/Free CPU validation required before release |
| AI | Admin-configured owner-operated Ollama behind reviewed adapter | Host/model configured later | ADR-004 | Worker-reachable HTTPS only; later adapters allowed; no end-user BYOK UI |
| Queue/workflow | Neon transactional outbox + Cloudflare Workflows; Queues optional later | Selected, versions/config absent | ADR-006 | Imports, AI, billing, exports and deletion; quota/recovery tests pending |
| Object storage | Cloudflare R2 EU via S3-compatible adapter | Provider interface accepted | ADR-008 | Admin-configurable reviewed providers; short-lived access |
| Infrastructure | Two Cloudflare Workers projects connected to GitHub | Free initially | ADR-006; no IaC | Independent API/admin deployments; quotas and global compute are explicit constraints |
| Runtime secret storage | Envelope-encrypted ciphertext in Neon; root key in Cloudflare Worker Secret | Crypto implementation unpinned | ADR-009; no code | Write-only admin configuration; rotation/recovery required |
