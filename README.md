# Codex Software Team Starter

A repo-scoped multi-agent operating model for OpenAI Codex in VS Code / Codex CLI.

## What this installs

- `AGENTS.md`: durable operating rules and delivery workflow.
- `.codex/agents/*.toml`: specialist Codex custom agents.
- `.agents/skills/*/SKILL.md`: reusable project workflows and expertise.
- `docs/`: fixed documentation information architecture.
- `tmp/`: mandatory scratch area for temporary artifacts.
- `scripts/quality-gate.sh`: configurable local quality gate.
- `.codex/rules/default.rules`: prompts before high-impact commands.

## First use

1. Copy the contents of this starter into the root of your existing repository.
2. Open that repository root in VS Code.
3. Ensure Codex trusts the project so project-scoped `.codex/` config is loaded.
4. Restart/reload Codex if needed.
5. In Codex, run `/status` and `/debug-config` to verify project configuration.
6. Run `/skills` and confirm the repo skills are visible.
7. Ask:

   `Bootstrap this repository using the project-bootstrap skill. Inspect the existing stack and docs, configure the quality gate, and do not change product behavior.`

8. Review `.codex/quality-gate.env` after bootstrap.
9. For real merge/deploy enforcement, wire `scripts/quality-gate.sh` into CI and require it in branch protection.

## Day-to-day use

You can write normal product requests. The root `AGENTS.md` instructs Codex to send every request through a concise Product Manager triage, ask you only for material product/technical decisions, delegate ordinary decisions across specialists, and require independent QA for production code changes plus risk-based Code Review before completion.

Example:

`Add organization-level audit-log export with CSV and JSON formats.`

Example for a complex cross-layer feature:

`PM -> PO -> only relevant architecture/security/data specialists -> human checkpoint only if needed -> affected implementers -> QA -> code review -> applicable docs/release gate`

## Design principle

Use `AGENTS.md` for rules that apply to almost every task. Use skills for focused reusable workflows. Use custom agents for role specialization. This avoids one giant instruction prompt and keeps context cleaner.

## Mobile roles

The package includes dedicated native mobile specialists:

- `android_developer` — Android/Kotlin/Java, Jetpack Compose/XML, lifecycle, permissions, storage, networking, background work, testing, performance.
- `ios_developer` — iOS/Swift/Objective-C, SwiftUI/UIKit, lifecycle, entitlements, storage, networking, background work, testing, performance.
- `mobile-engineering` skill — shared mobile best practices plus platform-specific checks and cross-platform guidance.

For Flutter, React Native, Kotlin Multiplatform, or similar repositories, Codex should keep shared implementation in the detected stack while still routing platform-specific native work to the Android/iOS specialist.


## DB-backed RBAC, tenancy and shared foundations

This starter treats application authorization as a server-side, database-backed concern. External identity providers may authenticate a user, but tenant memberships, roles, permissions, authorization-relevant lifecycle, and resource ownership remain durable application state.

Two reusable skills enforce this:
- `identity-access-multitenancy`
- `common-application-foundations`

Canonical documentation:
- `docs/03-architecture/application-foundations.md`
- `docs/04-engineering/identity-access-tenancy.md`
- `docs/04-engineering/common-data-conventions.md`
- `docs/05-security/authorization-and-tenant-isolation.md`

Feature templates include actor/tenant/permission matrices and cross-tenant negative-test requirements.


## Token-efficient adaptive orchestration

Every request still passes Product Manager triage, but Codex does not run the full team.

Routing is adaptive:
- L0: PM -> optional specialist
- L1: PM -> one implementer -> QA-lite
- L2: PM -> PO-lite -> affected specialists -> implementation -> QA -> review
- L3: PM -> PO -> risk specialists -> human gate if needed -> implementation -> QA -> review -> release

Agent communication is intentionally compact:
- pass file paths/symbols instead of copying documents;
- reuse existing conclusions;
- send only deltas;
- keep successful approvals short;
- persist large detail to `docs/` or `tmp/` and return pointers;
- do not spawn duplicate specialists.

The default concurrent subagent cap is 4 to reduce unnecessary parallel token consumption.

### Expected behavior example

A typo should not trigger Architect/Security/DB/PO/Reviewer.

A normal API feature may use:
`PM -> PO-lite -> Backend -> QA -> Reviewer`.

An RBAC/tenant migration may use:
`PM -> PO -> Architect + Security + DB -> Human Gate if needed -> Backend -> QA -> Reviewer -> Release Gate`.


## Regression safety

Production behavior-changing work uses `regression-safety` inside the already-selected roles; it does not spawn a separate regression agent.

The compact flow is:
`surface -> affected behavior -> preserve invariants -> baseline when useful -> change -> targeted regression -> broader checks by risk -> independent QA -> review when required`.

Bug fixes should demonstrate the defect before the fix with an automated regression test when practical. Shared/core, RBAC/tenant, public API, migration, concurrency, mobile lifecycle, and infrastructure changes get broader compatibility checks.

The quality-gate script suppresses successful command logs and only prints a bounded failure tail, reducing tool/output-token usage without hiding failures.

Team setup self-check: `bash scripts/validate-docs.sh && bash scripts/validate-team-contract.sh`.

`AGENTS.md` is intentionally a thin router/constitution; detailed domain rules live in progressively loaded skills to reduce per-request context tokens.
