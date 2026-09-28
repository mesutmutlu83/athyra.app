---
name: adaptive-orchestration
description: Route software work through the minimum necessary set of agents based on complexity, risk, affected layers, and decision gates while preserving PM intake and independent QA for code changes.
---

The goal is not to imitate a large organization. The goal is to use the smallest team that can safely complete the task.

## Mandatory PM intake

Every user request enters through Product Manager triage.
PM triage should be extremely short unless clarification is required.

The PM classifies:
- task type;
- complexity level;
- risk level, including regression risk;
- affected layers;
- affected canonical knowledge and its domain owner when the task produces a durable finding;
- human decision gates;
- minimum agent route.

Do not automatically spawn Product Owner, Architect, Security, DBA, UX, DevOps, Reviewer, Documentation, Android, iOS, FE, or BE.

## Complexity levels

### L0 — Answer / analysis / no repository change
Typical:
- explain existing behavior;
- answer a repo question;
- locate information;
- compare existing options without changing code.

Default route:
`PM -> relevant read-only specialist only if needed -> answer`

Do not invoke QA/reviewer for a non-change request.

### L1 — Small, low-risk change
Typical:
- typo/copy;
- tiny CSS/layout fix;
- narrow test fix;
- small isolated bug with no architecture/security/data/API impact;
- local config/documentation correction.

Default route:
`PM -> one implementer -> QA-lite -> final`

QA-lite means the same independent QA agent with a narrow, risk-based test scope; it is not self-testing by the implementer.
Add Code Reviewer only if code/regression risk or scope justifies it.
Do not invoke PO/Architect/UX/Security/DB/DevOps unless triggered.

### L2 — Standard feature/change
Typical:
- normal feature;
- multi-file business change;
- API + UI change;
- non-trivial bug;
- ordinary DB migration;
- mobile feature with backend interaction.

Default route:
`PM -> PO-lite -> only affected specialists -> implementer(s) -> QA -> Code Review -> docs if durable -> final`

### L3 — Complex / high-risk
Typical:
- authentication/authorization/RBAC/tenant changes;
- destructive or high-risk DB changes;
- architecture/topology changes;
- public API breaking change;
- payments/security/privacy/compliance;
- major framework/datastore/vendor changes;
- cross-platform feature touching many layers;
- production infrastructure change.

Default route:
`PM -> PO -> relevant Architect/Security/DB/UX/DevOps specialists -> Human Decision Gate if required -> implementer(s) -> QA -> Code Review -> docs/release gate -> final`

Only invoke specialists whose domain is actually affected.

## Risk triggers

Escalate one level when a task affects:
- authn/authz/RBAC/tenancy/ownership;
- data migration/integrity;
- public API compatibility;
- secrets/privacy/payment;
- production infrastructure;
- concurrency/transactions;
- destructive operations;
- cross-platform native behavior;
- external side effects;
- performance/reliability at critical scale;
- shared/core code or a change with broad regression blast radius.

## Specialist trigger matrix

Invoke only when applicable:

- Product Owner: acceptance criteria are non-trivial or behavior spans multiple cases.
- UX/UI: user flow, interaction, design system, accessibility, navigation, state behavior changes.
- System Architect: boundaries/contracts/components/technology topology materially change.
- Security: trust boundary, auth, authorization, sensitive data, secrets, files, unsafe input, tenant isolation.
- DB Architect: persistent schema/index/query/migration/transaction/retention changes.
- FE: browser/frontend implementation.
- Android: Android/native Android behavior.
- iOS: iOS/native iOS behavior.
- BE: API/domain/integration/job/backend implementation.
- DevOps/SRE: CI/CD/runtime/container/infrastructure/deployment/observability.
- Researcher: external/current evidence is necessary.
- Documentation Engineer: durable cross-cutting documentation or multiple canonical docs require reconciliation.
- Code Reviewer: L2/L3 by default; L1 only when risk warrants it.
- QA: every production code change. Scope may be QA-lite for L1.
- Regression safety: every production behavior-changing code/schema/config/dependency/infrastructure change; use the skill inside existing assigned roles, not a separate agent.

## Agent budget

Default maximum concurrently active specialist threads:
- L0: 0–1 specialist;
- L1: 1 implementer + QA;
- L2: 2–4 specialists/implementers total as needed;
- L3: as required, but avoid duplicate roles and cap concurrent read-only exploration unless broader parallelism clearly saves time.

Do not spawn two agents to answer the same question unless independent verification is justified.

## Reuse existing work

Before spawning another agent:
1. check whether the needed conclusion already exists in current task state or canonical docs;
2. reuse it if still valid;
3. do not ask another agent to rediscover the same information.

## Stop condition

Stop delegating when:
- the requested work is complete;
- acceptance criteria are satisfied;
- applicable QA/review gates have evidence;
- no unresolved Human Decision Gate remains.

Do not generate ceremonial review, planning, or documentation work after the stop condition merely because a role exists.
