#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

fail=0
# Keep root instructions compact; detailed domain rules belong in progressive skills.
agents_bytes=$(wc -c < AGENTS.md)
if [[ "$agents_bytes" -gt 14000 ]]; then echo "AGENTS_TOO_LARGE: $agents_bytes bytes"; fail=1; fi
need_file() {
  if [[ ! -f "$1" ]]; then echo "MISSING: $1"; fail=1; fi
}
need_text() {
  local file="$1" text="$2" label="$3"
  if ! grep -Fq -- "$text" "$file"; then echo "MISSING_RULE: $label in $file"; fail=1; fi
}
for f in \
  .agents/skills/adaptive-orchestration/SKILL.md \
  .agents/skills/concise-agent-communication/SKILL.md \
  .agents/skills/regression-safety/SKILL.md \
  .agents/skills/knowledge-management/SKILL.md \
  .agents/skills/agent-run-review/SKILL.md \
  .agents/skills/weekly-knowledge-scan/SKILL.md \
  .agents/skills/release-gate/SKILL.md \
  docs/00-governance/rule-precedence.md \
  docs/06-testing/regression-strategy.md; do
  need_file "$f"
done

need_text AGENTS.md 'code reviewer returns `CODE_REVIEW_APPROVED` when Code Review is required' 'conditional code review'
need_text AGENTS.md 'regression evidence is sufficient' 'release regression evidence'
need_text .codex/agents/qa-engineer.toml 'Add regression-safety for production behavior changes' 'QA regression ownership'
need_text .codex/agents/code-reviewer.toml 'regression-safety' 'review regression ownership'
need_text .codex/agents/backend-engineer.toml 'regression-safety' 'backend regression ownership'
need_text .codex/agents/frontend-engineer.toml 'regression-safety' 'frontend regression ownership'
need_text .codex/agents/android-developer.toml 'regression-safety' 'android regression ownership'
need_text .codex/agents/ios-developer.toml 'regression-safety' 'ios regression ownership'
need_text .codex/agents/db-architect.toml 'regression-safety' 'db regression ownership'


need_text AGENTS.md 'The root Delivery Orchestrator owns final Release Gate evaluation.' 'release gate ownership'
need_text AGENTS.md 'docs/00-governance/knowledge-management.md' 'knowledge management policy'
need_text AGENTS.md 'docs/00-governance/weekly-knowledge-scan.md' 'weekly knowledge scan policy'
need_text AGENTS.md 'docs/00-governance/agent-effectiveness.md' 'agent run review policy'
need_text .codex/agents/product-manager.toml 'docs/01-product/outcome-measurement.md' 'PM outcome review ownership'
for f in .codex/agents/*.toml; do
  need_text "$f" 'use knowledge-management' 'agent knowledge workflow'
done
need_text .agents/skills/regression-safety/SKILL.md 'Maintain one task-level regression packet' 'single regression packet'
need_text docs/00-governance/rule-precedence.md 'Token/context/output efficiency' 'rule precedence'
if grep -Fq -- 'Use testing-quality, security-engineering, identity-access-multitenancy, common-application-foundations, and release-gate skills.' .codex/agents/qa-engineer.toml; then
  echo 'CONFLICT: QA loads release gate and excess skills unconditionally'
  fail=1
fi

# Known contradiction guards.
if grep -Fq -- '- CODE_REVIEW_APPROVED;' docs/00-governance/definition-of-done.md; then
  echo 'CONFLICT: Definition of Done still requires Code Review unconditionally'
  fail=1
fi
if grep -Fq -- 'Code Review Gate — independent review; `CODE_REVIEW_APPROVED` required.' docs/00-governance/quality-gates.md; then
  echo 'CONFLICT: Quality Gates still requires Code Review unconditionally'
  fail=1
fi
if grep -Fq -- 'and release-gate skills.' .codex/agents/qa-engineer.toml; then
  echo 'CONFLICT: QA should not own final release-gate skill'
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo TEAM_CONTRACT_OK
