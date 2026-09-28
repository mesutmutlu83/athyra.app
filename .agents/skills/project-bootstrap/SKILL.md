---
name: project-bootstrap
description: Bootstrap or reconcile an existing software repository for this Codex team system. Use when the team setup is first added, the tech stack changes, or quality-gate commands/docs are missing.
---

1. Read AGENTS.md and docs/README.md.
2. Inspect the repository before changing anything:
   - language/toolchain manifests;
   - package/dependency lock files;
   - build files;
   - test configuration;
   - lint/format/type-check configuration;
   - container/infrastructure files;
   - CI workflows;
   - runtime configuration patterns;
   - source directory structure.
3. Update `docs/04-engineering/tech-stack.md` with observed versions and evidence paths.
4. Populate `.codex/quality-gate.env` using ONLY commands that actually exist or can be derived unambiguously from the repository's existing toolchain. Set `REGRESSION_TEST_CMD` only if a distinct regression suite exists; do not duplicate another configured suite.
5. If the repository has no testing capability, do not invent one silently. Report the gap and treat adoption of a new test framework as a Human Decision Gate when it materially changes the stack.
6. Reconcile the fixed documentation structure without deleting existing product knowledge.
7. Do not change product behavior during bootstrap.
8. Put scratch investigation output under `tmp/bootstrap/`.
9. Return discovered stack, configured commands, missing quality capabilities, and any human decisions required.

10. Configure the team for adaptive orchestration: do not add project-specific agents unless a recurring specialization truly requires one.
11. Prefer compact canonical docs over copied/redundant documentation.
