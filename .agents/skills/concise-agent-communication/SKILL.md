---
name: concise-agent-communication
description: Minimize token use in multi-agent software work through small handoff packets, delta-only communication, targeted file references, bounded outputs, and elimination of repeated context.
---

All agent-to-agent communication should be information-dense and task-oriented.

## Core rules

1. Do not repeat the user's request verbatim unless necessary to disambiguate.
2. Do not repeat repository-wide rules already present in `AGENTS.md`.
3. Do not paste whole documents when a file path/section reference is enough.
4. Do not narrate obvious reasoning steps.
5. Do not restate another agent's findings unless adding a delta, correction, conflict, or decision.
6. Prefer file paths, symbols, requirement IDs, and concise evidence over prose.
7. Read only the files needed for the task; avoid scanning the whole repository unless discovery requires it.
8. Report only material findings.
9. Separate facts from decisions and unresolved questions.
10. Use compact structured handoffs.

## Parent -> specialist handoff

Use this compact packet when delegating:

TASK:
SCOPE:
AC:
FILES:
DECISIONS:
NEED:

Rules:
- omit empty fields;
- `FILES` should point to canonical files/symbols rather than embedding their full contents;
- `DECISIONS` contains only already-approved constraints the specialist must honor;
- `NEED` states the exact output expected.

## Specialist -> parent response

Use:

STATUS: PASS | BLOCKED | CHANGES_NEEDED | INFO
KEY:
- ...
RISKS:
- ...
HANDOFF:
- ...

Only include sections that contain material information.

For an implementation agent, `KEY` should summarize changed files/behavior, not reproduce diffs.
For QA/review agents, list failures first. If clean, a one-line approval plus executed checks is sufficient.


## Regression handoff

For behavior-changing work, append only this compact packet when material:

```text
REGRESSION:
RISK:
SURFACE:
AFFECTED:
PRESERVE:
TESTS:
BLOCKERS:
```

Do not copy dependency graphs or test logs into chat. Use paths/symbols/test names. QA should consume this packet and report only deltas/gaps.

## Tool/log output economy

- Prefer quiet/concise test modes when the repository already provides them.
- When commands are noisy, store full output under `tmp/` and return a summary; on failure expose only the useful tail/context required to debug.
- Never hide a failure to save tokens.

## Output budgets

Targets, not hard truncation:
- PM triage: <= 120 words unless questions are required.
- PO acceptance packet: <= 250 words for L1/L2 unless complexity requires more.
- Specialist analysis: <= 300 words by default.
- Architecture/security/DB review: <= 400 words unless there are multiple material risks.
- Implementer handoff: <= 200 words plus file list/check results.
- QA approval: <= 150 words when passing; failures may be longer as needed.
- Code review approval: <= 150 words when passing; findings may be longer as needed.
- Final user response: concise by default; include only outcome, important decisions, checks, and unresolved items.

Do not spend tokens to hit the budget exactly. Use fewer words when possible.

## Delta protocol

When responding to previous agent work:
- `UNCHANGED` means prior conclusion still stands;
- `ADD` means new material information;
- `CORRECT` means a specific prior statement is wrong;
- `BLOCK` means a release/decision blocker.

Do not regenerate the full plan after a small delta.

## Questions

Ask the human only for decisions that cross the Human Decision Gate or materially change the result.
Group human questions into one compact batch.
Do not ask questions answerable from code/docs/tooling.

## Large evidence

When output would be large:
- write durable detail into the correct repository doc if it belongs there;
- write temporary analysis to `tmp/<task>/<role>/`;
- return only a short pointer + conclusion to the parent.

Agent chat is not a storage layer.
