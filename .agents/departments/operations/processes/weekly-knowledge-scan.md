# Weekly Knowledge Scan Operations

Owner: DevOps/SRE. The [governance runbook](../../governance/processes/weekly-knowledge-scan.md) defines role scope and evidence rules; [activation status](../../governance/knowledge/weekly-scan-status.md) records whether this Mac has the schedule installed.

The macOS user LaunchAgent runs one job each Monday at 09:00 in the host's Europe/Istanbul time zone. Its pinned bundle under `~/Library/Application Support/Athyra/weekly-scan/current/` contains the runner, validator, role instructions, and fixed HTTPS source list. Each role receives bounded source text as input to a tool-free Codex call. The job writes candidate reports, source indexes, role logs, and status files to `tmp/weekly-knowledge-scan/`; it does not edit canonical docs.

## Commands

From the repository root, after the required security, QA, and code-review checks:

```sh
bash scripts/weekly-knowledge-scan.sh "$PWD" --dry-run
bash scripts/install-weekly-knowledge-scan.sh
launchctl print "gui/$(id -u)/app.athyra.weekly-knowledge-scan"
```

Inspect `tmp/weekly-knowledge-scan/YYYY-Www.status` and its named candidate/log/source files after each run. After the current repository bundle is installed, a successful status means all 16 role rows passed structural and source checks; it does not mean a finding is verified or promoted. The accountable domain owner validates each candidate and updates the canonical document in a separate reviewed task. A failed run retains the last successful source baseline. For one manual retry in the same ISO week, use the installed pinned runner:

```sh
bash "$HOME/Library/Application Support/Athyra/weekly-scan/current/runner.sh" "$PWD" --retry-failed
```

After a runner/helper/source manifest/role prompt change or Codex CLI upgrade, recheck tool-free behavior and gates, then uninstall and reinstall to refresh the pinned bundle and binary hash. The uninstall command preserves historical status and reports:

```sh
bash scripts/uninstall-weekly-knowledge-scan.sh
```

The Mac must be available for the job to run. Check the status files after an outage; a powered-off Mac may miss its calendar run. A new computer needs its own installation and verification.
