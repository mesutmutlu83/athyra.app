---
name: stack-specific-engineering
description: Detect the repository's actual languages, framework/library versions, build tools, and conventions before coding; apply version-correct engineering guidance and authoritative documentation.
---

Before code edits:
1. Inspect manifests, lockfiles, toolchain files, build files, and existing source patterns.
2. Read `docs/04-engineering/tech-stack.md` and correct it if stale.
3. Determine exact versions when behavior/API is version-sensitive.
4. Prefer repository conventions over generic examples.
5. Consult authoritative documentation for uncertain/version-specific APIs.
6. Never claim a library option/API exists without verifying it when uncertainty is material.
7. Do not upgrade frameworks or major dependencies as a side effect of unrelated work.
8. Record a required upgrade as a separate decision/work item.
