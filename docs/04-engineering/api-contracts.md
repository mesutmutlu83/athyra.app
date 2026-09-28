# API Contracts

No executable API specification exists yet. The source brief defines required capability families; exact paths may follow the chosen backend conventions.

- Identity/session/account lifecycle and onboarding.
- Athlete profile, goals, availability, check-ins, feedback, and user reports.
- Data-source connections, capabilities, consent, local health binding, idempotent import batches, coverage, and provenance.
- Strategy/weekly-plan generation, jobs, proposals, publication, sessions, adaptations, and reconciliation.
- Coach relationships, scoped athlete access, and private content.
- AI connections with write-only secrets, capability testing, budgets, and task policies.
- Catalog sports, variants, methods, content versions, support matrices, imports, reviews, and releases.
- Admin staff/RBAC, scoped users, CRM, support, membership, entitlements, billing, reconciliation, reports, exports, and audit.
- FEAT-002 admin metadata/content/integration/config/feature-flag change sets, validation, publish, rollback and verification; exact routes follow the v1 admin namespace when implemented.
- Filtered read-only app configuration, catalog-version and integration-discovery snapshots with schema/release version, ETag and compatibility metadata.

Cross-cutting requirements: server authorization, idempotency, optimistic concurrency/version checks, pagination, stable error semantics, audit/outbox, backward-compatible schema evolution, and no secret or unnecessary health payload in events.

Admin and app contracts are separate. Public/app responses never include drafts, secret references/ciphertext, internal capability evidence, admin notes or privileged configuration. Publish/rollback operations require explicit expected revision, idempotency key, reason and step-up context.
