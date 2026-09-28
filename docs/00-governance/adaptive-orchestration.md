# Adaptive Orchestration and Token Efficiency

The team uses the minimum number of agents required to complete work safely.

## Routing levels

| Level | Typical work | Default route |
|---|---|---|
| L0 | Answer/analysis, no repo change | PM -> optional specialist |
| L1 | Small low-risk change | PM -> implementer -> independent QA-lite |
| L2 | Standard feature/change | PM -> PO-lite -> affected specialists -> implementation -> QA -> review |
| L3 | Complex/high-risk | PM -> PO -> risk specialists -> human gate if needed -> implementation -> QA -> review -> release |

Every request passes PM triage. Other roles are conditional.

## Required independent checks

- Any production code change receives independent QA.
- Code review is mandatory for L2/L3 and risk-triggered L1.
- Security/DB/Architecture review is invoked by impact, not by habit.
- Documentation Engineer is invoked only when durable cross-cutting docs need reconciliation; implementers may update narrow feature docs directly.

## Token-efficiency rules

- Give agents references, not copied context.
- Reuse existing conclusions.
- Avoid duplicate research/review.
- Share deltas only.
- Keep passing approvals extremely short.
- Persist large durable detail to files and return pointers.
- Do not spawn roles that do not affect the task.
- Do not produce ceremonial artifacts.

QA-lite means the normal independent QA role with a narrow risk-based scope; it never means developer self-approval. Regression safety runs inside already-assigned roles and does not create a new agent.
