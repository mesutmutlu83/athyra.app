#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

python3 "$ROOT/scripts/validate-project-docs.py"

if [[ -e "$ROOT/docs/00-governance" || -e "$ROOT/docs/07-operations/weekly-knowledge-scan.md" || \
      -e "$ROOT/docs/06-testing/regression-strategy.md" || -e "$ROOT/docs/04-engineering/coding-standards.md" ]]; then
  echo "AGENT_DOCS_IN_APP_DOCS"
  exit 1
fi

python3 "$ROOT/scripts/validate-document-links.py" docs

echo "DOC_STRUCTURE_OK"
