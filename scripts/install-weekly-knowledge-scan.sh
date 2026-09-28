#!/bin/bash
set -euo pipefail
umask 077

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
RUNNER="$SCRIPT_DIR/weekly-knowledge-scan.sh"
STATE_DIR="$REPO_ROOT/tmp/weekly-knowledge-scan"
LABEL=app.athyra.weekly-knowledge-scan
AGENT_DIR="${HOME:?}/Library/LaunchAgents"
AGENT_PLIST="$AGENT_DIR/$LABEL.plist"
SUPPORT_DIR="${HOME:?}/Library/Application Support/Athyra/weekly-scan"
BUNDLE_DIR="$SUPPORT_DIR/current"
PINNED_RUNNER="$BUNDLE_DIR/runner.sh"
CODEX_EXECUTABLE="${CODEX_BIN:-$(command -v codex || true)}"

if [[ "$(uname -s)" != Darwin ]]; then
  echo "This installer requires macOS launchd." >&2
  exit 69
fi
if [[ "$(readlink /etc/localtime 2>/dev/null || true)" != */Europe/Istanbul ]]; then
  echo "Set the Mac's local time zone to Europe/Istanbul before installing this schedule." >&2
  exit 65
fi
if [[ -z "$CODEX_EXECUTABLE" || ! -x "$CODEX_EXECUTABLE" ]]; then
  echo "Codex CLI unavailable; install it or set CODEX_BIN to an executable path." >&2
  exit 69
fi
if [[ "$CODEX_EXECUTABLE" != /* ]]; then
  echo "CODEX_BIN must resolve to an absolute executable path." >&2
  exit 64
fi
if [[ -e "$AGENT_PLIST" || -L "$AGENT_PLIST" || -e "$BUNDLE_DIR" || -L "$BUNDLE_DIR" ]]; then
  echo "Weekly scanner is already installed or its pinned bundle exists. Uninstall before replacing it." >&2
  exit 73
fi

/bin/bash "$RUNNER" "$REPO_ROOT" --dry-run >/dev/null
for source_dir in "$REPO_ROOT/.codex/agents" "$REPO_ROOT/.agents/skills"; do
  if [[ ! -d "$source_dir" || -L "$source_dir" || \
        "$(cd "$source_dir" && pwd -P)" != "$REPO_ROOT"/* ]]; then
    echo "Unsafe or missing pinned bundle input: $source_dir" >&2
    exit 65
  fi
done

mkdir -p "$AGENT_DIR" "$STATE_DIR" "$SUPPORT_DIR"
if [[ -L "$SUPPORT_DIR" || "$(cd "$SUPPORT_DIR" && pwd -P)" == "$REPO_ROOT"/* ]]; then
  echo "Pinned runner directory must be a real directory outside the repository." >&2
  exit 65
fi
chmod 700 "$SUPPORT_DIR"
TEMP_BUNDLE="$(mktemp -d "$SUPPORT_DIR/.bundle.XXXXXX")"
TEMP_PLIST="$(mktemp "$AGENT_DIR/.$LABEL.XXXXXX")"
INSTALL_FINISHED=no
cleanup_install() {
  rm -rf "$TEMP_BUNDLE"
  rm -f "$TEMP_PLIST"
  if [[ "$INSTALL_FINISHED" != yes ]]; then
    rm -rf "$BUNDLE_DIR"
  fi
}
trap cleanup_install EXIT
mkdir -p "$TEMP_BUNDLE/agents" "$TEMP_BUNDLE/skills"
cp "$RUNNER" "$TEMP_BUNDLE/runner.sh"
cp "$SCRIPT_DIR/weekly-knowledge-scan-helper.pl" "$TEMP_BUNDLE/helper.pl"
cp "$SCRIPT_DIR/weekly-knowledge-sources.txt" "$TEMP_BUNDLE/sources.txt"
/usr/bin/shasum -a 256 "$CODEX_EXECUTABLE" | /usr/bin/awk '{print $1}' \
  >"$TEMP_BUNDLE/codex-sha256.txt"
: >"$TEMP_BUNDLE/.athyra-weekly-generated"
if [[ -n "$(/usr/bin/find "$REPO_ROOT/.codex/agents" -type l -print -quit)" ]]; then
  echo "Agent profile tree contains a symlink; refusing installation." >&2
  exit 65
fi
PROFILE_COUNT=0
while IFS= read -r -d '' profile; do
  profile_name="${profile##*/}"
  if [[ -e "$TEMP_BUNDLE/agents/$profile_name" ]]; then
    echo "Duplicate agent profile filename: $profile_name" >&2
    exit 65
  fi
  cp "$profile" "$TEMP_BUNDLE/agents/$profile_name"
  PROFILE_COUNT=$((PROFILE_COUNT + 1))
done < <(/usr/bin/find "$REPO_ROOT/.codex/agents" -type f -name '*.toml' -print0)
EXPECTED_PROFILE_COUNT="$(/usr/bin/perl "$SCRIPT_DIR/weekly-knowledge-scan-helper.pl" roster | /usr/bin/wc -l | /usr/bin/tr -d '[:space:]')"
if [[ "$PROFILE_COUNT" -ne "$EXPECTED_PROFILE_COUNT" ]]; then
  echo "Expected $EXPECTED_PROFILE_COUNT agent profiles; found $PROFILE_COUNT." >&2
  exit 65
fi
while IFS='|' read -r role slug; do
  if [[ ! -f "$TEMP_BUNDLE/agents/$slug.toml" ]]; then
    echo "Missing agent profile for $role: $slug.toml" >&2
    exit 65
  fi
done < <(/usr/bin/perl "$SCRIPT_DIR/weekly-knowledge-scan-helper.pl" roster)
for skill_name in weekly-knowledge-scan knowledge-management; do
  skill_dir="$(cd "$REPO_ROOT/.agents/skills/$skill_name" && pwd -P)"
  if [[ "$skill_dir" != "$REPO_ROOT"/* ]]; then
    echo "Skill source resolves outside the repository: $skill_name" >&2
    exit 65
  fi
  mkdir -p "$TEMP_BUNDLE/skills/$skill_name"
  cp "$REPO_ROOT/.agents/skills/$skill_name/SKILL.md" \
    "$TEMP_BUNDLE/skills/$skill_name/SKILL.md"
done
if [[ -n "$(/usr/bin/find "$TEMP_BUNDLE" -type l -print -quit)" ]]; then
  echo "Pinned bundle contains a symlink; refusing installation." >&2
  exit 65
fi
chmod -R u+rwX,go-rwx "$TEMP_BUNDLE"
chmod 700 "$TEMP_BUNDLE/runner.sh"
cp "$SCRIPT_DIR/weekly-knowledge-scan.launchd.plist" "$TEMP_PLIST"
/usr/bin/plutil -insert ProgramArguments.1 -string "$PINNED_RUNNER" "$TEMP_PLIST"
/usr/bin/plutil -insert ProgramArguments.2 -string "$REPO_ROOT" "$TEMP_PLIST"
/usr/bin/plutil -replace EnvironmentVariables.CODEX_BIN -string "$CODEX_EXECUTABLE" "$TEMP_PLIST"
/usr/bin/plutil -replace StandardOutPath -string "$STATE_DIR/launchd.stdout.log" "$TEMP_PLIST"
/usr/bin/plutil -replace StandardErrorPath -string "$STATE_DIR/launchd.stderr.log" "$TEMP_PLIST"
/usr/bin/plutil -lint "$TEMP_PLIST" >/dev/null
if [[ "$(/usr/bin/plutil -extract ProgramArguments.0 raw "$TEMP_PLIST")" != /bin/bash || \
      "$(/usr/bin/plutil -extract ProgramArguments.1 raw "$TEMP_PLIST")" != "$PINNED_RUNNER" || \
      "$(/usr/bin/plutil -extract ProgramArguments.2 raw "$TEMP_PLIST")" != "$REPO_ROOT" ]] || \
      /usr/bin/plutil -extract ProgramArguments.3 raw "$TEMP_PLIST" >/dev/null 2>&1; then
  echo "Installed launchd arguments do not match the expected three values." >&2
  exit 65
fi
chmod 600 "$TEMP_PLIST"
mv "$TEMP_BUNDLE" "$BUNDLE_DIR"
mv "$TEMP_PLIST" "$AGENT_PLIST"
if ! /bin/launchctl bootstrap "gui/$(id -u)" "$AGENT_PLIST"; then
  rm -f "$AGENT_PLIST"
  echo "launchd bootstrap failed; installation rolled back." >&2
  exit 1
fi
INSTALL_FINISHED=yes
trap - EXIT
echo "Installed $LABEL for Mondays at 09:00 Mac local time."
echo "Pinned runner: $PINNED_RUNNER"
echo "Status and logs: $STATE_DIR"
