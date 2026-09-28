---
name: frontend-engineering
description: Implement/review frontend behavior using the detected stack, existing design system, state management patterns, accessibility, responsive design, performance, security boundaries, and tests.
---

Use `regression-safety` for behavior-changing frontend work, especially shared components/state/API consumers.
Use approved UX and acceptance criteria.
Reuse established components and state/data-fetching patterns.
Handle all relevant states.
Maintain semantic HTML/accessibility and keyboard/focus behavior.
Keep authorization enforced on the server even when the UI hides actions. Render UX from backend-provided effective capabilities rather than scattered hard-coded role-name checks.
Avoid unnecessary client state.
Avoid avoidable re-renders/bundles only when material.
Test user-visible behavior at the most stable useful level.
