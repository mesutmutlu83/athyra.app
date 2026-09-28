# Knowledge and Lessons Management

## Purpose and source of truth

Sportapp product and system facts belong in the relevant numbered `docs/` directory. Agent workflow, prompt, skill, routing, and handoff findings belong in `.agents/departments/<owner>/knowledge/`; cross-department agent-system findings belong in [shared agent knowledge](../knowledge/README.md). A reusable finding should link to the authoritative app document or verified run evidence rather than copy it. Product decisions, UX specifications, ADRs, technical contracts, security policy, test evidence, app runbooks, and release records remain authoritative under `docs/`. An agent knowledge entry cannot silently change an approved decision or claim unimplemented behavior.

`tmp/` holds investigation notes and raw logs. A verified finding enters persistent guidance only when it has an owner, evidence, a validation outcome, and a useful durable consequence. An actionable but unverified finding may be recorded as a `candidate` with an owner and next validation step; it must not guide implementation as fact. Feature-specific findings link to the relevant `docs/features/<FEATURE-ID>/` record; they are not copied into multiple department files.

## Ownership

| Directory | Accountable owner | Canonical documents and lesson placement |
|---|---|---|
| `01-product/` | Product Manager | [Strategy](../../../../docs/01-product/strategy.md), vision, roadmap and product decisions; Product Owner owns acceptance detail |
| `02-ux/` | UX/UI Designer | User flows, design system and accessibility |
| `03-architecture/` | System Architect | System context, components, data flow and ADRs; DB Architect owns schema-specific input |
| `04-engineering/` | Implementer for affected layer | Tech stack, contracts, data model and configuration; DB Architect owns data-model input |
| `05-security/` | Security Engineer | Threat model, data classification and security requirements |
| `06-testing/` | QA Engineer | Product test strategy, test matrix and traceability; agent regression process is under `.agents/departments/testing/processes/` |
| `07-operations/` | DevOps/SRE | Deployment, environments, observability and runbooks |
| `08-release/` | Delivery Orchestrator | Release process and changelog, with QA/DevOps evidence |
| `09-marketing/` | Marketing Specialist | Evidence-backed product marketing context; campaigns and claims remain decision-gated |

Documentation Engineer reconciles placement, links, provenance and wording with the accountable owner. Every selected agent checks the relevant application documents and its department's agent knowledge at task start, proposing an update when work changes or invalidates an entry. The owner validates domain accuracy. Marketing Specialist owns marketing context and proposals; Product Management retains product strategy and commercial decisions. Agent-specific lessons stay in `.agents/`, while app facts stay in `docs/`.

## Event-driven update loop

1. At intake, check the affected canonical documents and recorded findings for applicable assumptions, known lessons, and review dates.
2. During code, schema, configuration, dependency, API, UX, product, security, test, operations, or release work, record material new evidence and check whether existing claims still hold. An incident, defect, failed test, user feedback, provider notice, or relevant external research result is also a trigger.
3. Update the authoritative app document or obtain the required human decision first when the finding affects product behavior or policy. Record a reusable agent-process lesson in the owning `.agents/departments/<owner>/knowledge/` directory; record app facts in the relevant `docs/` document. Include source, observation date, validator, confidence, applicability, and links. For a lesson, record the action that will prevent recurrence and how it was checked.
4. Before handoff, the implementer or specialist flags changed/stale knowledge; QA checks evidence for affected behavior; Documentation Engineer checks the canonical links and unresolved labels. The Delivery Orchestrator evaluates any release-relevant gap.

This loop runs when an agent performs a task or receives a configured research/event trigger. The [weekly scan](weekly-knowledge-scan.md) is a bounded periodic, read-only candidate trigger with a separate activation record. Its findings enter canonical guidance only through a reviewed follow-up task; it does not imply continuous internet monitoring or guaranteed discovery of every change.

## Entry contract

Use a short entry or table row with these fields when a durable finding exists:

| Field | Required meaning |
|---|---|
| ID and title | Stable local reference, e.g. `UX-K-001` or `OPS-L-001` (`K` knowledge, `L` lesson) |
| Status | `candidate`, `verified`, `stale`, `superseded`, or `rejected`; only `verified` guides current work |
| Claim and scope | What was learned, where and when it applies, and what remains uncertain |
| Evidence | Direct link to authoritative internal evidence or primary external source; distinguish source publication date from observation date |
| Validation | Named role/agent, date, method, and confidence (`high`, `medium`, `low`) with reason; a cited source alone is not implementation verification |
| Review trigger | Event or date that requires rechecking a time-sensitive claim |
| Consequence | Canonical document/decision updated, action owner and verification result; lessons also state the failure/context and prevention action |
| Supersedes | Prior entry ID and replacement link when applicable; retain traceability |

Do not infer implementation from approved requirements, planned architecture, or a passing document review. For repository behavior, inspect code/config and use actual test/runtime evidence. For external claims, prefer primary sources and verify the source's current applicability, version, jurisdiction, and publication date. Research results first enter as `candidate`; the accountable owner validates them against the product and, where relevant, implementation/test evidence before marking them `verified`. A material scope, security, architecture, privacy, pricing, or contract change follows the [decision policy](../rules/decision-policy.md) rather than an autonomous knowledge edit.

## Stale, conflicting, and superseded information

Mark an entry `stale` when its source changes, review date passes, implementation contradicts it, or validation cannot be reproduced. State what is uncertain and route it to the owner; do not present it as current guidance. When sources conflict, retain both references, record the conflict, prefer the approved decision and directly verified system evidence for their respective claims, and request a decision if the conflict crosses a human gate. Replace obsolete advice with a linked `superseded` entry; never silently overwrite the history of a lesson. An unresolved high-risk conflict blocks the affected acceptance or release claim.
