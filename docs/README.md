# Documentation Information Architecture

This directory is the persistent source-of-truth for the product and system.

## Fixed structure

- `00-governance/` — rule precedence, decision policy, adaptive orchestration, agent communication, knowledge management, Definition of Ready/Done, quality gates.
- `00-governance/weekly-knowledge-scan.md` — weekly domain evidence scan and source roster; `weekly-scan-status.md` records activation and per-role checks.
- `00-governance/agent-effectiveness.md` — evidence from completed agent runs and the monthly skill/prompt review.
- `01-product/` — product vision, roadmap, personas, durable product decisions.
- `01-product/outcome-measurement.md` — proposed product outcome measures, baseline state, and PM review cadence.
- `02-ux/` — design system, global flows, accessibility, screen references.
- `03-architecture/` — system context, components, integrations, data flow, shared application foundations, ADRs.
- `04-engineering/` — tech stack, coding standards, API contracts, data model, configuration, identity/access/tenancy and common data conventions.
- `05-security/` — threat model, data classification, security requirements.
- `06-testing/` — test strategy, regression strategy, test matrix, traceability.
- `07-operations/` — environments, deployment, observability, runbooks, including [weekly knowledge scan operations](07-operations/weekly-knowledge-scan.md).
- `08-release/` — release process and changelog.
- `features/<FEATURE-ID>/` — one folder per meaningful feature/change.

Each numbered directory holds that functional area's canonical documentation. [Knowledge management](00-governance/knowledge-management.md) defines owners, update triggers, evidence, validation, and supersession for reusable findings and lessons. Record a lesson in the affected canonical document, or create a focused knowledge file in that directory when several durable findings need an index. Do not create empty department stubs or duplicate authoritative facts. Product strategy is maintained in [strategy.md](01-product/strategy.md) by Product Management.

## Feature folder contract

Each meaningful feature should use the applicable files:

- `brief.md` — problem, objective, scope, owner/status.
- `requirements.md` — requirements and acceptance criteria.
- `ux.md` — flow/state/accessibility design.
- `architecture.md` — technical impact and links to ADRs.
- `security.md` — threat/security impact.
- `test-plan.md` — requirement-to-test evidence.
- `status.md` — current lifecycle status and unresolved items.
- `release-note.md` — user-visible release note when applicable.

Do not create parallel permanent documentation trees elsewhere in the repository without an explicit architecture/governance decision.

Temporary artifacts belong in `tmp/`, never here.

Shared application foundations are canonical: features should link to/reuse them rather than defining parallel RBAC, settings, audit, notification, file, pagination, or similar mechanisms.
