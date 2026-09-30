# Sportapp Documentation

This directory contains the durable product, design, system, delivery, and release documentation for the Sportapp sports application. Approved plans and target architecture are distinguished from implemented and verified behavior in the linked documents.

## Application documentation

- [Product](01-product/README.md) — vision, approved scope, roadmap, decisions, and outcome measurement.
- [Initial source coverage](01-product/document-coverage.md) — document-by-document evidence and missing information from the supplied project brief.
- [UX and design](02-ux/README.md) — athlete, coach, and admin flows; interface and accessibility requirements.
- [Architecture and data](03-architecture/README.md) — system context, components, integrations, data flow, and architecture decisions.
- [Engineering](04-engineering/README.md) — selected stack, API and data contracts, identity, and configuration.
- [Security](05-security/README.md) — threats, data classes, authorization, and security requirements.
- [Testing](06-testing/README.md) — product test strategy, matrix, and requirement traceability.
- [Operations](07-operations/README.md) — application environments, deployment, and observability.
- [Release](08-release/README.md) — release conditions and user-visible changelog.
- [Marketing](09-marketing/README.md) — product context and evidence for future positioning work.
- [Features](features/README.md) — feature-specific scope, design, architecture, security, and verification records.
- [Transfer tools](miscellaneous/README.md) — user-requested scripts to move the global Codex team to another computer.

## Documentation boundaries

Record a product or implementation fact in its relevant application document and link to it from feature records when needed. Feature-specific material belongs under `features/<FEATURE-ID>/`; material architecture decisions belong under `03-architecture/adrs/`. Do not duplicate authoritative facts across files.

The agent team's reusable prompts, skills, rules, processes, knowledge base, and lessons live in the user-wide `~/.agents/codex-team/` and `~/.codex/` directories. Athyra-specific scanner activation and Codebase Memory verification notes are under `~/.agents/codex-team/state/projects/athyra.app/`; weekly scan outputs are in `tmp/weekly-knowledge-scan/`, and the Codebase Memory graph uses its own local cache. Temporary investigation artifacts belong in `tmp/`.
