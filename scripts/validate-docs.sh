#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

required=(
  "docs/README.md"
  "docs/00-governance/definition-of-ready.md"
  "docs/00-governance/definition-of-done.md"
  "docs/00-governance/quality-gates.md"
  "docs/06-testing/regression-strategy.md"
  "docs/00-governance/rule-precedence.md"
  "docs/00-governance/agent-communication-protocol.md"
  "docs/00-governance/adaptive-orchestration.md"
  "docs/00-governance/knowledge-management.md"
  "docs/00-governance/weekly-knowledge-scan.md"
  "docs/00-governance/weekly-scan-status.md"
  "docs/00-governance/agent-system-comparison-2026-09-28.md"
  "docs/00-governance/agent-effectiveness.md"
  "docs/07-operations/weekly-knowledge-scan.md"
  "docs/01-product/vision.md"
  "docs/01-product/strategy.md"
  "docs/01-product/outcome-measurement.md"
  "docs/02-ux/design-system.md"
  "docs/03-architecture/system-context.md"
  "docs/05-security/authorization-and-tenant-isolation.md"
  "docs/04-engineering/common-data-conventions.md"
  "docs/04-engineering/identity-access-tenancy.md"
  "docs/03-architecture/application-foundations.md"
  "docs/04-engineering/tech-stack.md"
  "docs/05-security/threat-model.md"
  "docs/06-testing/test-strategy.md"
  "docs/07-operations/deployment.md"
  "docs/08-release/release-process.md"
  ".agents/skills/knowledge-management/SKILL.md"
  ".agents/skills/agent-run-review/SKILL.md"
  ".agents/skills/weekly-knowledge-scan/SKILL.md"
)

missing=0
for f in "${required[@]}"; do
  if [[ ! -f "$ROOT/$f" ]]; then
    echo "MISSING: $f"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  exit 1
fi

echo "DOC_STRUCTURE_OK"
