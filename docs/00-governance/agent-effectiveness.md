# Agent Run Review

Owner: Product Manager for routing and priority; Documentation Engineer for this record and skill/prompt consistency. QA and Code Reviewer provide independent evidence for affected work. This is the canonical process for improving the agent system from actual runs; [knowledge management](knowledge-management.md) governs verified lessons.

## Trigger and cadence

At a task handoff, the Delivery Orchestrator records a material agent-system surprise: user correction, QA rejection, missed acceptance, unexpected runtime result, avoidable repeated work, or misleading skill/prompt instruction. Routine successful turns need no entry. On the first product/team work cycle after the first Monday of each month, PM and Documentation Engineer review the available completed-run entries and a small sample of recent completed tasks. First review due: **2026-10-05**. This cadence is checked at intake, not a separate timed job. If there are no eligible runs, record `no evidence/no change` with the next review date; do not create synthetic scores.

For each reviewed run, keep a compact, sanitized record: stable task reference and date; role and skill/prompt path or version; expected and observed result; direct QA, reviewer, user, or runtime evidence; likely cause (`implementation`, `test process`, `routing`, `skill/prompt`, `tool`, or `unknown`); proposed action; owner; verification; status. Use a task path or local report reference instead of raw chat logs. Never persist secrets, personal data, health details, or complete transcripts. Count reviewed runs and evidence-backed issues only when the underlying sample exists; no quality percentage or target is inferred from one case.

The owner changes the narrowest relevant instruction only when the evidence supports it. Before/after verification may be a focused replay, actual generated artifact inspection, or another check that exercises the failure path. Independent QA/review still applies to code changes. For an ambiguous cause, leave an open hypothesis and next check; do not modify prompts merely to match another repository or a single stylistic preference. Resolve conflicting or obsolete instructions under [rule precedence](rule-precedence.md).

## Reviewed evidence

| ID / observed | Task and affected role | Expected / observed evidence | Cause and action | Verification / status |
|---|---|---|---|---|
| AIR-001 / 2026-09-28 | Weekly knowledge scan installation; DevOps/SRE and QA. Affected instruction: [testing-quality](../../.agents/skills/testing-quality/SKILL.md). | A loaded launchd job needed exactly `/bin/bash`, pinned runner, and repo path. In the 2026-09-28 delivery session, `plutil -p` and `launchctl print` showed five arguments after an initially passing mock and template lint: the expected three followed by literal `__PINNED_RUNNER_PATH__` and `__REPO_ROOT__`. This is a sanitized transcription of live output; the pre-fix plist was not retained in the repo. | Test-process gap: the template was checked, but the rendered installed argument list was not checked before the first approval. Installer now inserts into a one-argument template and rejects a fourth argument. The testing skill adds a narrow generated-job inspection rule. | The installed plist and launchd job showed exactly three arguments and Monday 09:00; independent QA and Code Review approved the correction. Verified. See [operations runbook](../07-operations/weekly-knowledge-scan.md) and [activation record](weekly-scan-status.md). |

Next monthly review: **2026-10-05**. AIR-001 is one verified incident, not a measured failure rate or evidence that every agent prompt needs revision.
