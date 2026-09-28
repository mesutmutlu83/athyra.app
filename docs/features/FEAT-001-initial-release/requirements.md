# FEAT-001 Requirements

This is a domain-level index. It does not replace the 230 source feature IDs or 220 source test IDs.

| Domain | Required observable outcome |
|---|---|
| Identity/account | Application-owned email/password plus verified Apple/Google identities access one durable user; secure recovery/linking/session/deletion; roles do not grant data access |
| Consent/data | Source access, platform processing, raw-health AI sharing, coach sharing and notifications are separate; AI selection is task-bounded; revocation stops affected new work |
| Health/application import | Official supported read-only routes, provenance/freshness/granularity, idempotent sync, no invented detail or source mutation |
| Profile/planning | Sport-specific goals/availability/equipment; feasible multi-sport weekly plan; explicit unknown/infeasible states; versioned approval |
| Adaptation | Imported records and user reports remain distinguishable; proposed changes explain cause/effect and respect authority/locks |
| AI | Initial owner-operated Ollama is configured by an authorized owner through a secure admin flow and performs supported real tasks through a provider-neutral validated gateway; later reviewed adapters remain possible; no silent fallback or end-user BYOK/custom URL |
| Catalog | Versioned, rights-aware, multi-dimensional sports/content model; complete pinned source staging; expert-reviewed planning capability |
| Coach | Native scoped athlete workspace, plan edit/approval, private content/notes and revocable relationship without owning athlete history |
| Admin/RBAC | Invitation+MFA, deny-by-default DB permissions, scoped dashboard/users/settings/audit, no default health/secret access |
| CRM/support | One contact per user, tags/notes/tasks/cases, public reply vs internal note separation, retention and deletion safety |
| Membership/entitlement | Account, membership, payment, entitlement, role and consent stay separate; Free/Pro limits follow PD-002; expired users retain privacy/support paths |
| Billing | Only approved channels; provider-authoritative verification, trial/grace/retry/refund/revocation/restore/account-transfer behavior selected in PD-002; idempotency, reconciliation, exact money, account ownership and environment isolation |
| Compatibility/release | Approved iPhone/OS/toolchain matrix, dependency evidence, physical-device/admin-browser tests, backward-compatible API and safe rollback |

## Acceptance baseline

- Every applicable P0 source feature maps to test evidence.
- No unverified integration, OS combination, sport capability, payment event, or health value is represented as complete.
- Accepted decisions and remaining follow-up gates in `PD-001-bootstrap-decisions.md` are resolved before their dependent release claim.
- Scope exclusions remain absent from code, capabilities, permissions, and marketing claims.
