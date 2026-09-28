# Personas / Actors

| Actor | Primary goals | Key boundaries |
|---|---|---|
| Athlete | Set goals, connect optional data sources, approve plans, review and adapt training | Cannot access another athlete; data-source, AI, and coach permissions are separate |
| Coach | Work with explicitly authorized athletes, edit plans, approve proposals, keep private coaching notes | Access is athlete-scoped; no access to secrets or unrelated health data |
| Platform owner/admin | Operate users, memberships, product settings, billing records, and policy | MFA and DB-backed permissions; no default raw-health, coach-note, or AI-secret access |
| Support staff | Handle narrow user-card, case, note, and follow-up workflows | Cannot change roles, prices, or payments; health access is not implied |
| Finance staff | Review pricing, memberships, transactions, reconciliation, and permitted actions | No health/coach content or AI secrets; cannot manage staff roles |
| Organization manager | P1 institutional administration | Organization administration is not platform administration or health access |

A single user may be both athlete and coach. Personal athlete context, managed-athlete context, and admin staff membership remain distinct.
