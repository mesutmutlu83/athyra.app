# Roles and Skills Map

Skills are progressively loaded. `Core` means normally loaded when that role is invoked; `Conditional` means load only when the task touches that concern.
The [department indexes](../../../../docs/README.md) assign one accountable owner to every agent prompt and skill. This table describes usage, including cross-department skills; it does not create a second owner.

| Role | Core skills | Conditional skills |
|---|---|---|
| Product Manager | adaptive-orchestration, concise-agent-communication | intake-discovery, product-management, identity-access-multitenancy, common-application-foundations, market-intelligence, competitor-research |
| Product Owner | product-management | identity-access-multitenancy, common-application-foundations, testing-quality |
| Product Researcher | market-intelligence / competitor-research as assigned | none by default |
| Marketing Specialist | product-marketing | market-intelligence, competitor-research, knowledge-management |
| UX/UI Designer | ux-product-design | regression-safety |
| System Architect | architecture-design, stack-specific-engineering | coding-standards, security-engineering, identity-access-multitenancy, common-application-foundations, regression-safety |
| Security Engineer | security-engineering | identity-access-multitenancy, common-application-foundations, code-review, regression-safety |
| Frontend Engineer | stack-specific-engineering, coding-standards, frontend-engineering, testing-quality | security-engineering, identity-access-multitenancy, common-application-foundations, regression-safety |
| Android Developer | stack-specific-engineering, coding-standards, mobile-engineering, testing-quality | security-engineering, identity-access-multitenancy, common-application-foundations, regression-safety |
| iOS Developer | stack-specific-engineering, coding-standards, mobile-engineering, testing-quality | security-engineering, identity-access-multitenancy, common-application-foundations, regression-safety |
| Backend Engineer | stack-specific-engineering, coding-standards, backend-engineering, testing-quality | database-engineering, security-engineering, identity-access-multitenancy, common-application-foundations, regression-safety |
| DB Architect/DBA | database-engineering | regression-safety, identity-access-multitenancy, common-application-foundations, architecture-design, security-engineering, testing-quality |
| QA Engineer | testing-quality | regression-safety, security-engineering, identity-access-multitenancy, common-application-foundations |
| Code Reviewer | code-review, coding-standards | stack-specific-engineering, regression-safety, security-engineering, identity-access-multitenancy, common-application-foundations |
| DevOps/SRE | devops-sre | security-engineering, architecture-design, regression-safety, release-gate when explicitly assigned final release verification |
| Documentation Engineer | documentation-governance | common-application-foundations, identity-access-multitenancy; release-gate only if explicitly assigned release-documentation verification |

The root Codex thread is the Delivery Orchestrator. Every request receives concise Product Manager triage; other roles are conditional.

`regression-safety` is not an agent. It is loaded inside already-selected roles only when production behavior can regress.

`knowledge-management` is a cross-role skill for checking and updating the owning area's canonical documents when work produces a verified finding, lesson, changed fact, or stale assumption. The [knowledge workflow](../processes/knowledge-management.md) defines ownership, provenance, validation, and supersession; it does not add a standing agent to every route. Product strategy belongs to the Product Manager and [strategy.md](../../../../docs/01-product/strategy.md). Marketing context and proposals belong to the [Marketing Specialist](../../../../docs/09-marketing/README.md); campaign execution needs separate authorization.

`weekly-knowledge-scan` is invoked by the single scheduled orchestration or an explicit catch-up. Every configured specialist assesses its assigned area in the [weekly roster](../processes/weekly-knowledge-scan.md), with the root respecting the concurrent-agent cap and recording [per-role status](../knowledge/weekly-scan-status.md).

`agent-run-review` is loaded by PM/Documentation Engineer only for a material observed agent-system issue or the [monthly review](../knowledge/agent-effectiveness.md). It does not turn every task into a broad prompt audit. PM owns the [product outcome review](../../../../docs/01-product/outcome-measurement.md), with Product Owner input on definitions and human approval for binding targets.
