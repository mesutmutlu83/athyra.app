#!/bin/bash
set -euo pipefail

LABEL=app.athyra.weekly-knowledge-scan
AGENT_PLIST="${HOME:?}/Library/LaunchAgents/$LABEL.plist"
BUNDLE_DIR="${HOME:?}/Library/Application Support/Athyra/weekly-scan/current"
PINNED_RUNNER="$BUNDLE_DIR/runner.sh"
if [[ "$(uname -s)" != Darwin ]]; then
  echo "This uninstaller requires macOS launchd." >&2
  exit 69
fi
if [[ ! -f "$AGENT_PLIST" ]]; then
  if [[ -f "$PINNED_RUNNER" ]]; then
    if [[ ! -f "$BUNDLE_DIR/.athyra-weekly-generated" ]]; then
      echo "Pinned bundle lacks its ownership marker; refusing removal." >&2
      exit 65
    fi
    rm -rf "$BUNDLE_DIR"
    echo "Removed orphaned pinned weekly scanner bundle."
  fi
  echo "$LABEL is not installed."
  exit 0
fi
INSTALLED_LABEL="$(/usr/bin/plutil -extract Label raw "$AGENT_PLIST")"
if [[ "$INSTALLED_LABEL" != "$LABEL" ]]; then
  echo "Unexpected plist label in $AGENT_PLIST; refusing removal." >&2
  exit 65
fi
INSTALLED_RUNNER="$(/usr/bin/plutil -extract ProgramArguments.1 raw "$AGENT_PLIST")"
if [[ "$INSTALLED_RUNNER" != "$PINNED_RUNNER" ]]; then
  echo "Unexpected runner path in $AGENT_PLIST; refusing removal." >&2
  exit 65
fi
if [[ ! -f "$BUNDLE_DIR/.athyra-weekly-generated" ]]; then
  echo "Pinned bundle lacks its ownership marker; refusing removal." >&2
  exit 65
fi
if ! /bin/launchctl bootout "gui/$(id -u)" "$AGENT_PLIST"; then
  if /bin/launchctl print "gui/$(id -u)/$LABEL" >/dev/null 2>&1; then
    echo "launchd job is still active; refusing to remove its plist." >&2
    exit 1
  fi
  echo "launchd job was already unloaded; removing its plist."
fi
rm "$AGENT_PLIST"
rm -rf "$BUNDLE_DIR"
echo "Uninstalled $LABEL. Existing scan logs and status files were retained."
