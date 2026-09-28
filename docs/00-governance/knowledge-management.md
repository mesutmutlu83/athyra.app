# Knowledge and Lessons Management

## Purpose and source of truth

Each functional area owns the canonical documents in its numbered `docs/` directory. Reusable, verified findings and lessons belong in the most relevant canonical document. Create a focused `knowledge.md` in that directory only when several durable findings need a common index; link to authoritative documents instead of copying them. Product requirements and decisions, UX specifications, ADRs, technical contracts, security policy, test evidence, runbooks, and release records remain authoritative in their existing canonical locations. A knowledge entry cannot silently change an approved decision or claim an unimplemented behavior.

`tmp/` holds investigation notes and raw logs. A verified finding enters persistent guidance only when it has an owner, evidence, a validation outcome, and a useful durable consequence. An actionable but unverified finding may be recorded as a `candidate` with an owner and next validation step; it must not guide implementation as fact. Feature-specific findings link to the relevant `docs/features/<FEATURE-ID>/` record; they are not copied into multiple department files.

## Ownership

| Directory | Accountable owner | Canonical documents and lesson placement |
|---|---|---|
| `01-product/` | Product Manager | [Strategy](../01-product/strategy.md), vision, roadmap and product decisions; Product Owner owns acceptance detail |
| `02-ux/` | UX/UI Designer | User flows, design system and accessibility |
| `03-architecture/` | System Architect | System context, components, data flow and ADRs; DB Architect owns schema-specific input |
| `04-engineering/` | Implementer for affected layer | Tech stack, contracts, data model and configuration; DB Architect owns data-model input |
| `05-security/` | Security Engineer | Threat model, data classification and security requirements |
| `06-testing/` | QA Engineer | Test strategy, regression strategy, test matrix and traceability |
| `07-operations/` | DevOps/SRE | Deployment, environments, observability and runbooks |
| `08-release/` | Delivery Orchestrator | Release process and changelog, with QA/DevOps evidence |

Documentation Engineer reconciles placement, links, provenance and wording with the accountable owner. Every selected agent checks the relevant functional area's documents at task start and proposes an update when its work changes or invalidates an entry. The owner validates domain accuracy. Marketing has no standing agent or department in this repository. If marketing work is commissioned, assign its owner and canonical documents explicitly; Product Management's strategy ownership does not imply ownership of campaigns or channel execution.

## Event-driven update loop

1. At intake, check the affected canonical documents and recorded findings for applicable assumptions, known lessons, and review dates.
2. During code, schema, configuration, dependency, API, UX, product, security, test, operations, or release work, record material new evidence and check whether existing claims still hold. An incident, defect, failed test, user feedback, provider notice, or relevant external research result is also a trigger.
3. Update the authoritative document or obtain the required human decision first. Then add or revise only the reusable finding in the owning directory. Record the source, observation date, validator, confidence, applicability, and links. For a lesson, record the action that will prevent recurrence and how that action was checked.
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

Do not infer implementation from approved requirements, planned architecture, or a passing document review. For repository behavior, inspect code/config and use actual test/runtime evidence. For external claims, prefer primary sources and verify the source's current applicability, version, jurisdiction, and publication date. Research results first enter as `candidate`; the accountable owner validates them against the product and, where relevant, implementation/test evidence before marking them `verified`. A material scope, security, architecture, privacy, pricing, or contract change follows the [decision policy](decision-policy.md) rather than an autonomous knowledge edit.

## Stale, conflicting, and superseded information

Mark an entry `stale` when its source changes, review date passes, implementation contradicts it, or validation cannot be reproduced. State what is uncertain and route it to the owner; do not present it as current guidance. When sources conflict, retain both references, record the conflict, prefer the approved decision and directly verified system evidence for their respective claims, and request a decision if the conflict crosses a human gate. Replace obsolete advice with a linked `superseded` entry; never silently overwrite the history of a lesson. An unresolved high-risk conflict blocks the affected acceptance or release claim.
