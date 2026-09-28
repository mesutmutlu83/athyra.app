#!/bin/bash
set -euo pipefail
umask 077

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="${1:-}"
if [[ -z "$REPO_ROOT" || ! -d "$REPO_ROOT" ]]; then
  echo "Usage: $0 REPO_ROOT [--dry-run | --retry-failed]" >&2
  exit 64
fi
REPO_ROOT="$(cd "$REPO_ROOT" && pwd -P)"
shift
STATE_DIR="$REPO_ROOT/tmp/weekly-knowledge-scan"
MAX_SECONDS=5400
ROLE_SECONDS=300

usage() {
  echo "Usage: $0 REPO_ROOT [--dry-run | --retry-failed]" >&2
  exit 64
}

case "${1:-}" in
  --dry-run)
    [[ "$#" -eq 1 ]] || usage
    ;;
  --locked)
    [[ "$#" -eq 1 ]] || usage
    ;;
  --retry-failed)
    [[ "$#" -eq 1 ]] || usage
    mkdir -p "$STATE_DIR"
    exec /usr/bin/lockf -s -t 0 "$STATE_DIR/run.lock" /bin/bash "$0" "$REPO_ROOT" --retry-locked
    ;;
  --retry-locked)
    [[ "$#" -eq 1 ]] || usage
    ;;
  "")
    [[ "$#" -eq 0 ]] || usage
    mkdir -p "$STATE_DIR"
    # lockf holds an OS file lock until the child exits; concurrent jobs exit here.
    exec /usr/bin/lockf -s -t 0 "$STATE_DIR/run.lock" /bin/bash "$0" "$REPO_ROOT" --locked
    ;;
  *) usage ;;
esac

CODEX_EXECUTABLE="${CODEX_BIN:-$(command -v codex || true)}"
if [[ -z "$CODEX_EXECUTABLE" || ! -x "$CODEX_EXECUTABLE" ]]; then
  echo "Codex CLI unavailable; install it or set CODEX_BIN to its absolute executable path." >&2
  exit 69
fi
if [[ "$CODEX_EXECUTABLE" != /* ]]; then
  echo "CODEX_BIN must resolve to an absolute executable path." >&2
  exit 64
fi
for required in \
  "$REPO_ROOT/docs/00-governance/weekly-knowledge-scan.md" \
  "$REPO_ROOT/docs/00-governance/weekly-scan-status.md" \
  "$REPO_ROOT/.agents/skills/weekly-knowledge-scan/SKILL.md"; do
  if [[ ! -f "$required" ]]; then
    echo "Required weekly scan instruction missing: $required" >&2
    exit 66
  fi
done

if [[ "${1:-}" == "--dry-run" ]]; then
  echo "Repository: $REPO_ROOT"
  echo "Codex CLI: $CODEX_EXECUTABLE"
  echo "Schedule: launchd Monday 09:00 in the Mac's local time zone"
  echo "Run limit: $MAX_SECONDS seconds total, $ROLE_SECONDS seconds per role; one scheduled attempt per ISO week"
  echo "Manual recovery: --retry-failed permits one retry after a recorded failure"
  echo "Mode: pinned HTTPS sources, 15 tool-free role calls, candidate report only"
  exit 0
fi

EXPECTED_RUNNER_DIR="${HOME:?}/Library/Application Support/Athyra/weekly-scan/current"
if [[ "$SCRIPT_DIR" != "$EXPECTED_RUNNER_DIR" ]]; then
  echo "Run the installed pinned runner; use install-weekly-knowledge-scan.sh first." >&2
  exit 77
fi
SUPPORT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
PINNED_SOURCES="$SCRIPT_DIR/sources.txt"
for pinned in "$PINNED_SOURCES" "$SCRIPT_DIR/helper.pl" \
  "$SCRIPT_DIR/codex-sha256.txt" "$SCRIPT_DIR/.athyra-weekly-generated"; do
  if [[ ! -f "$pinned" || -L "$pinned" ]]; then
    echo "Pinned weekly scanner input missing or unsafe: $pinned" >&2
    exit 65
  fi
done
INSTALLED_CODEX_SHA="$(cat "$SCRIPT_DIR/codex-sha256.txt")"
CURRENT_CODEX_SHA="$(/usr/bin/shasum -a 256 "$CODEX_EXECUTABLE" | /usr/bin/awk '{print $1}')"
if [[ ! "$INSTALLED_CODEX_SHA" =~ ^[a-f0-9]{64}$ || "$CURRENT_CODEX_SHA" != "$INSTALLED_CODEX_SHA" ]]; then
  echo "Codex CLI binary changed since scanner installation; review tool availability and reinstall." >&2
  exit 65
fi

WEEK_ID="$(date '+%G-W%V')"
ATTEMPT_FILE="$STATE_DIR/$WEEK_ID.attempt"
STATUS_FILE="$STATE_DIR/$WEEK_ID.status"
RUN_LOG="$STATE_DIR/$WEEK_ID.log"
CANDIDATE_REPORT="$STATE_DIR/$WEEK_ID.candidate.md"
SOURCE_INDEX="$STATE_DIR/$WEEK_ID.sources.txt"
RETRY_FILE="$STATE_DIR/$WEEK_ID.retry.attempt"
RUN_SUFFIX=scheduled

if [[ "${1:-}" == "--retry-locked" ]]; then
  if [[ ! -f "$ATTEMPT_FILE" || ! -f "$STATUS_FILE" ]] || \
     ! /usr/bin/grep -Fxq 'state=failed' "$STATUS_FILE"; then
    echo "Manual retry requires a recorded failed attempt for $WEEK_ID." >&2
    exit 65
  fi
  if [[ -e "$RETRY_FILE" ]]; then
    echo "Manual retry already attempted for $WEEK_ID; see $STATUS_FILE" >&2
    exit 73
  fi
  RUN_LOG="$STATE_DIR/$WEEK_ID.retry.log"
  CANDIDATE_REPORT="$STATE_DIR/$WEEK_ID.retry.candidate.md"
  SOURCE_INDEX="$STATE_DIR/$WEEK_ID.retry.sources.txt"
  RUN_SUFFIX=retry
  printf 'retry_started=%s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" >"$RETRY_FILE"
else
  if [[ -e "$ATTEMPT_FILE" ]]; then
    echo "Weekly knowledge scan already attempted for $WEEK_ID; see $STATUS_FILE"
    exit 0
  fi
  # Record before starting so a failed or timed-out run cannot repeat silently.
  printf 'started=%s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" >"$ATTEMPT_FILE"
fi

RUN_STARTED_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
RUN_DEADLINE=$(( $(date '+%s') + MAX_SECONDS ))
: >"$RUN_LOG"
printf 'state=running\nstarted_utc=%s\nlog=%s\ncandidate=%s\nsources=%s\n' \
  "$RUN_STARTED_UTC" "$RUN_LOG" "$CANDIDATE_REPORT" "$SOURCE_INDEX" >"$STATUS_FILE"
RUN_FINALIZED=no
on_exit() {
  local run_rc=$?
  if [[ "$RUN_FINALIZED" != yes ]]; then
    printf 'Scan setup or execution aborted (exit %s).\n' "$run_rc" >>"$RUN_LOG"
    printf 'state=failed\nfinished=%s\nexit_code=%s\nlog=%s\ncandidate=%s\nsources=%s\n' \
      "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$run_rc" "$RUN_LOG" "$CANDIDATE_REPORT" "$SOURCE_INDEX" >"$STATUS_FILE"
    /usr/bin/logger -t athyra-weekly-knowledge-scan \
      "Weekly scan setup failed (exit $run_rc); inspect $STATUS_FILE"
  fi
}
trap on_exit EXIT
SNAPSHOT="$SUPPORT_ROOT/runs/$WEEK_ID/$RUN_SUFFIX"
for local_file in "$REPO_ROOT/docs/01-product/strategy.md" \
  "$REPO_ROOT/docs/04-engineering/tech-stack.md"; do
  if [[ ! -f "$local_file" || -L "$local_file" ]]; then
    echo "Missing or unsafe bounded context file: $local_file" >&2
    exit 65
  fi
done
for previous in "$STATE_DIR/latest-success.candidate.md" "$STATE_DIR/latest-success.sources.txt"; do
  if [[ -L "$previous" ]]; then
    echo "Previous scan data is a symlink: $previous" >&2
    exit 65
  fi
done
if [[ -e "$SNAPSHOT" || -L "$SNAPSHOT" ]]; then
  echo "Scan workspace already exists: $SNAPSHOT" >&2
  exit 73
fi
mkdir -p "$SNAPSHOT/fetched-sources" "$SNAPSHOT/empty-workdir"
: >"$SNAPSHOT/source-index.txt"
SOURCE_COUNT=0
SEEN_SOURCE_IDS='|'
while IFS='|' read -r source_id assigned_roles source_url extra; do
  [[ -z "$source_id" || "$source_id" == \#* ]] && continue
  if [[ ! "$source_id" =~ ^[a-z0-9][a-z0-9_-]*$ || \
        -z "$assigned_roles" || "$source_url" != https://* || -n "${extra:-}" ]]; then
    echo "Invalid pinned source manifest entry: $source_id" >&2
    exit 65
  fi
  if [[ "$SEEN_SOURCE_IDS" == *"|$source_id|"* ]]; then
    echo "Duplicate pinned source ID: $source_id" >&2
    exit 65
  fi
  SEEN_SOURCE_IDS+="$source_id|"
  SOURCE_COUNT=$((SOURCE_COUNT + 1))
  source_file="$SNAPSHOT/fetched-sources/$source_id.html"
  source_temp="$source_file.partial"
  http_code="$(/usr/bin/env -i PATH=/usr/bin:/bin /usr/bin/curl -q \
    --silent --show-error --fail --proto '=https' \
    --connect-timeout 8 --max-time 20 --max-filesize 2097152 \
    --output "$source_temp" --write-out '%{http_code}' \
    "$source_url" 2>>"$RUN_LOG")" && fetch_rc=0 || fetch_rc=$?
  if [[ "$fetch_rc" -eq 0 && "$http_code" == 200 && -s "$source_temp" ]]; then
    mv "$source_temp" "$source_file"
    source_state=ok
    source_sha="$(/usr/bin/shasum -a 256 "$source_file" | /usr/bin/awk '{print $1}')"
    source_delta=first_seen
    if [[ -f "$STATE_DIR/latest-success.sources.txt" ]]; then
      previous_entry="$(/usr/bin/awk -F'|' -v id="$source_id" '$1 == id {print $4 "|" $6; exit}' \
        "$STATE_DIR/latest-success.sources.txt")"
      if [[ -n "$previous_entry" ]]; then
        previous_state="${previous_entry%%|*}"
        previous_sha="${previous_entry#*|}"
        if [[ "$previous_state" == ok && "$previous_sha" =~ ^[a-f0-9]{64}$ ]]; then
          if [[ "$previous_sha" == "$source_sha" ]]; then
            source_delta=unchanged
          else
            source_delta=changed
          fi
        else
          source_delta=unknown
        fi
      fi
    fi
  else
    rm -f "$source_temp"
    source_state=failed
    source_sha=-
    source_delta=unavailable
    printf 'Source fetch failed: %s (curl=%s http=%s)\n' \
      "$source_id" "$fetch_rc" "$http_code" >>"$RUN_LOG"
  fi
  printf '%s|%s|%s|%s|%s|%s|%s\n' "$source_id" "$assigned_roles" "$source_url" \
    "$source_state" "fetched-sources/$source_id.html" "$source_sha" "$source_delta" \
    >>"$SNAPSHOT/source-index.txt"
done <"$PINNED_SOURCES"
if [[ "$SOURCE_COUNT" -eq 0 ]]; then
  echo "Pinned source manifest is empty." >&2
  exit 65
fi
cp "$SNAPSHOT/source-index.txt" "$SOURCE_INDEX"


# Each invocation receives only the packet on stdin. The workdir is empty, and
# all model-controlled file, browser, network, app, and delegation tools are off.
# The trusted runner handles fetches and artifact writes outside the model.
RUN_RC=0
printf '# Weekly knowledge scan candidate — %s\n\n' "$WEEK_ID" >"$CANDIDATE_REPORT"
printf 'Proposal only. Sources are pinned official pages; human review is required before canonical changes.\n\n' >>"$CANDIDATE_REPORT"
printf '| Agent | Last attempt UTC | Last success UTC | Result | Sources/findings/next action |\n' >>"$CANDIDATE_REPORT"
printf '| --- | --- | --- | --- | --- |\n' >>"$CANDIDATE_REPORT"
while IFS='|' read -r ROLE SLUG; do
  ROLE_LOG="$STATE_DIR/$WEEK_ID.$RUN_SUFFIX.$SLUG.log"
  ROLE_OUTPUT="$STATE_DIR/$WEEK_ID.$RUN_SUFFIX.$SLUG.output.md"
  ROLE_PACKET="$SNAPSHOT/$SLUG.packet.txt"
  ROLE_ROW="$SNAPSHOT/$SLUG.row.md"
  ROLE_STARTED_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  ROLE_RC=0
  if ! /usr/bin/perl "$SCRIPT_DIR/helper.pl" packet "$ROLE" "$ROLE_STARTED_UTC" \
      "$SOURCE_INDEX" "$SNAPSHOT" "$SCRIPT_DIR" "$REPO_ROOT" \
      "$STATE_DIR/latest-success.candidate.md" >"$ROLE_PACKET" 2>>"$RUN_LOG"; then
    ROLE_RC=65
  else
    REMAINING=$((RUN_DEADLINE - $(date '+%s')))
    if [[ "$REMAINING" -le 0 ]]; then
      printf 'Total scan deadline exceeded before %s.\n' "$ROLE" >>"$RUN_LOG"
      ROLE_RC=124
    else
      ROLE_LIMIT="$ROLE_SECONDS"
      if [[ "$REMAINING" -lt "$ROLE_LIMIT" ]]; then ROLE_LIMIT="$REMAINING"; fi
      set +e
      /usr/bin/perl -e '
        use strict;
        use warnings;
        my $limit = shift @ARGV;
        my $pid = fork();
        die "fork failed: $!\n" unless defined $pid;
        if ($pid == 0) {
          setpgrp(0, 0) or die "setpgrp failed: $!\n";
          exec @ARGV or die "exec failed: $!\n";
        }
        my $stop = sub {
          my ($exit_code) = @_;
          kill "TERM", -$pid;
          sleep 3;
          kill "KILL", -$pid;
          waitpid($pid, 0);
          exit $exit_code;
        };
        $SIG{ALRM} = sub { warn "Weekly role timed out\n"; $stop->(124) };
        $SIG{TERM} = sub { warn "Weekly role interrupted\n"; $stop->(143) };
        $SIG{INT} = sub { warn "Weekly role interrupted\n"; $stop->(130) };
        alarm $limit;
        waitpid($pid, 0);
        my $status = $?;
        alarm 0;
        exit(($status & 127) ? 128 + ($status & 127) : ($status >> 8));
      ' "$ROLE_LIMIT" "$CODEX_EXECUTABLE" exec \
        --sandbox read-only \
        -c 'approval_policy="never"' \
        -c 'web_search="disabled"' \
        --disable shell_tool \
        --disable unified_exec \
        --disable code_mode_host \
        --disable browser_use \
        --disable browser_use_external \
        --disable browser_use_full_cdp_access \
        --disable computer_use \
        --disable image_generation \
        --disable view_image \
        --disable apps \
        --disable plugins \
        --disable hooks \
        --disable multi_agent \
        --disable skill_search \
        --disable tool_suggest \
        --ignore-user-config \
        --ignore-rules \
        --skip-git-repo-check \
        -C "$SNAPSHOT/empty-workdir" \
        --ephemeral \
        --output-last-message "$ROLE_OUTPUT" \
        - <"$ROLE_PACKET" >"$ROLE_LOG" 2>&1
      ROLE_RC=$?
      set -e
    fi
  fi
  if [[ "$ROLE_RC" -eq 0 ]]; then
    if ! /usr/bin/perl "$SCRIPT_DIR/helper.pl" row "$ROLE" "$ROLE_STARTED_UTC" \
        "$SOURCE_INDEX" "$ROLE_OUTPUT" >"$ROLE_ROW" 2>>"$RUN_LOG"; then
      ROLE_RC=65
    fi
  fi
  if [[ "$ROLE_RC" -eq 0 ]]; then
    cat "$ROLE_ROW" >>"$CANDIDATE_REPORT"
  else
    RUN_RC=65
    PREVIOUS_SUCCESS='-'
    if [[ -f "$STATE_DIR/latest-success.candidate.md" ]]; then
      PREVIOUS_SUCCESS="$(/usr/bin/awk -F'|' -v role="$ROLE" '
        {r=$2; gsub(/^[[:space:]]+|[[:space:]]+$/, "", r);
         if (r==role) {s=$4; gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); print s; exit}}' \
        "$STATE_DIR/latest-success.candidate.md")"
      [[ -n "$PREVIOUS_SUCCESS" ]] || PREVIOUS_SUCCESS='-'
    fi
    printf '| %s | %s | %s | failed | Role call or evidence validation failed (exit %s); inspect %s |\n' \
      "$ROLE" "$ROLE_STARTED_UTC" "$PREVIOUS_SUCCESS" "$ROLE_RC" "$ROLE_LOG" >>"$CANDIDATE_REPORT"
    printf 'Role %s failed (exit %s); log %s\n' "$ROLE" "$ROLE_RC" "$ROLE_LOG" >>"$RUN_LOG"
  fi
done < <(/usr/bin/perl "$SCRIPT_DIR/helper.pl" roster)
if [[ "$RUN_RC" -eq 0 ]]; then
  ROLE_ROWS="$(/usr/bin/grep -c '^| ' "$CANDIDATE_REPORT" || true)"
  if [[ "$ROLE_ROWS" -ne 17 ]]; then
    echo "Candidate report did not contain exactly 15 role rows." >>"$RUN_LOG"
    RUN_RC=65
  fi
fi

if [[ "$RUN_RC" -eq 0 ]]; then
  RUN_STATE=success
  LATEST_TEMP="$(mktemp "$STATE_DIR/.latest-success.XXXXXX")"
  cp "$CANDIDATE_REPORT" "$LATEST_TEMP"
  mv "$LATEST_TEMP" "$STATE_DIR/latest-success.candidate.md"
  LATEST_SOURCE_TEMP="$(mktemp "$STATE_DIR/.latest-sources.XXXXXX")"
  cp "$SOURCE_INDEX" "$LATEST_SOURCE_TEMP"
  mv "$LATEST_SOURCE_TEMP" "$STATE_DIR/latest-success.sources.txt"
else
  RUN_STATE=failed
fi
printf 'state=%s\nfinished=%s\nexit_code=%s\nlog=%s\ncandidate=%s\nsources=%s\n' \
  "$RUN_STATE" "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$RUN_RC" "$RUN_LOG" "$CANDIDATE_REPORT" "$SOURCE_INDEX" >"$STATUS_FILE"
RUN_FINALIZED=yes

if [[ "$RUN_RC" -ne 0 ]]; then
  /usr/bin/logger -t athyra-weekly-knowledge-scan \
    "Weekly knowledge scan failed (exit $RUN_RC); inspect $STATUS_FILE and $RUN_LOG"
  echo "Weekly knowledge scan failed (exit $RUN_RC); see $RUN_LOG" >&2
fi
exit "$RUN_RC"
