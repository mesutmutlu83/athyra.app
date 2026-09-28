#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CFG="${QUALITY_GATE_CONFIG:-$ROOT/.codex/quality-gate.env}"

if [[ ! -f "$CFG" ]]; then
  echo "ERROR: quality-gate config not found: $CFG"
  exit 2
fi

# shellcheck disable=SC1090
source "$CFG"
TAIL_LINES="${QUALITY_GATE_FAILURE_TAIL_LINES:-120}"

run_check() {
  local name="$1"
  local cmd="$2"
  if [[ -z "${cmd// }" ]]; then
    echo "SKIP  $name"
    return 0
  fi

  local log
  log="$(mktemp)"
  local rc
  if (cd "$ROOT" && bash -lc "$cmd") >"$log" 2>&1; then
    rc=0
  else
    rc=$?
  fi

  if [[ "$rc" -eq 0 ]]; then
    echo "PASS  $name"
    rm -f "$log"
    return 0
  fi

  echo "FAIL  $name (exit $rc)"
  echo "--- failure output: last $TAIL_LINES lines ---"
  tail -n "$TAIL_LINES" "$log" || true
  rm -f "$log"
  return "$rc"
}

configured_tests=0
for v in "${UNIT_TEST_CMD:-}" "${INTEGRATION_TEST_CMD:-}" "${REGRESSION_TEST_CMD:-}" "${E2E_TEST_CMD:-}"; do
  if [[ -n "${v// }" ]]; then
    configured_tests=1
  fi
done

if [[ "${REQUIRE_TESTS:-true}" == "true" && "$configured_tests" -eq 0 ]]; then
  echo "ERROR: REQUIRE_TESTS=true but no test command is configured in $CFG"
  echo "Run the project-bootstrap skill and configure the repository's real test commands."
  exit 3
fi

run_check "Format check" "${FORMAT_CHECK_CMD:-}"
run_check "Lint" "${LINT_CMD:-}"
run_check "Type/static check" "${TYPECHECK_CMD:-}"
run_check "Build/compile" "${BUILD_CMD:-}"
run_check "Unit tests" "${UNIT_TEST_CMD:-}"
run_check "Integration tests" "${INTEGRATION_TEST_CMD:-}"
run_check "Regression tests" "${REGRESSION_TEST_CMD:-}"
run_check "End-to-end tests" "${E2E_TEST_CMD:-}"
run_check "Security scan" "${SECURITY_SCAN_CMD:-}"

echo "QUALITY_GATE_PASSED"
