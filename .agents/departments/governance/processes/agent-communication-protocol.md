# Agent Communication Protocol

## Delegation packet

```text
TASK:
SCOPE:
AC:
FILES:
DECISIONS:
NEED:
```

Omit unused fields. Reference canonical files instead of pasting them.

## Response packet

```text
STATUS: PASS | BLOCKED | CHANGES_NEEDED | INFO
KEY:
- ...
RISKS:
- ...
HANDOFF:
- ...
```

Use only material sections.

## Delta messages

```text
UNCHANGED: <what remains valid>
ADD: <new material fact>
CORRECT: <specific correction>
BLOCK: <blocking issue>
```

## Brevity

Passing QA/review responses should contain status + checks/evidence only.
Failure responses may be longer, but should identify exact files/symbols/requirements and expected correction.

No agent should restate the entire task, architecture, requirements, or previous findings without a specific need.


## Regression packet

For production behavior-changing work only:

```text
REGRESSION:
RISK:
SURFACE:
AFFECTED:
PRESERVE:
TESTS:
BLOCKERS:
```

Use paths/symbols/test names. QA reports only deltas/gaps rather than repeating this packet.
