# Portable Codex team transfer

This is a user-requested transfer-tooling exception under the Athyra documentation tree. It is **not Athyra application knowledge**. The scripts export the user-wide Codex and Claude Code team from `~/.agents/codex-team/`, `~/.codex/`, and the team-owned files under `~/.claude/`, then install them for another macOS or Linux user account.

## On the source computer

From the Athyra repository root, choose where the archive will be saved:

```sh
bash docs/miscellaneous/pack.sh --output "$HOME/Desktop/codex-team-portable.tar.gz"
```

Copy these four files to the new computer: `codex-team-portable.tar.gz`, `codex-team-portable.tar.gz.sha256`, `install.sh`, and `pack.sh`. Keep `pack.sh` there for a later transfer to another computer. Inspect the archive contents before transfer when they may include private team knowledge. Create the archive **after** editing the shared roles or skills so it includes the latest set. The packer discovers registered department roles and team skill links at run time.

Transfer the files through a trusted channel. The sidecar detects corruption; it does not prove who created the archive if an attacker can replace both files. Compare the packer's displayed SHA-256 through a separate trusted channel when source authenticity matters.

## On the new computer

Python 3.11 or newer and `curl` are required. The installer supports macOS and Linux. It uses OpenAI's [official standalone Codex installer](https://learn.chatgpt.com/docs/codex/cli), downloaded to a temporary file and syntax checked before running. Install Claude Code using [Anthropic's setup instructions](https://code.claude.com/docs/en/setup) if it is absent on the target computer. Account authentication is not migrated.

```sh
bash install.sh --archive ./codex-team-portable.tar.gz
codex login
claude --version
```

For an existing repository, you can install and then set up Codebase Memory for that specific project:

```sh
bash install.sh --archive ./codex-team-portable.tar.gz --project "$HOME/projects/my-app"
```

The `--project` option runs the pinned Codebase Memory setup and indexes only the named repository. Its release provenance check requires GitHub CLI (`gh`) if the pinned binary is not already installed. If Claude Code is present, register the Codebase Memory MCP for the user; otherwise register it after installing Claude with `claude mcp add --scope user codebase-memory-mcp -- "$HOME/.local/bin/codebase-memory-mcp"`. Run without `--project` to defer indexing until a project is available. Project repositories, documentation, Git history, auth, unrelated plugins/MCP accounts, machine-specific binaries, index/cache state, and weekly schedule activation are separate from this archive.

## What is copied and how conflicts work

The archive includes shared department processes, rules, lessons, scripts, templates, 21 registered Codex role prompts, 21 matching Claude role prompts (including three Codebase Memory profiles), the Codebase Memory skills, user-wide team instructions, and `team.rules`. The 31 department skill links are recreated for both clients against the new home path. Agent registrations are merged into `~/.codex/config.toml`; Claude's `settings.json` only gains the `CLAUDE.md` plus `AGENTS.md` instruction mode. Existing model, MCP, plugin, trust, hooks, and other settings are kept. Existing unrelated `~/.codex/AGENTS.md` text is retained around a managed team block.

The installer checks the companion SHA-256 file, every archive entry and file digest, and rejects links or paths that could escape the intended directories. If a target file has been customized, installation stops before changing files. On upgrades, files last installed by this tool can be replaced only while unchanged since that install. Any changed existing file is copied into `~/.agents/codex-team-backups/install-<UTC timestamp>/` before replacement. Re-running the same archive is safe. When upgrading an earlier portable install, unchanged Codebase Memory profiles at the old `~/.codex/agents/` root are backed up and removed after their Engineering replacements are installed; a customized old profile stops the upgrade for manual reconciliation.

For an offline test without installing Codex, use `--skip-codex --target-home /path/to/empty-home`. This flag is intended for verification; real project integration needs the relevant CLI. After changing a shared role or skill, run `python3 ~/.agents/codex-team/scripts/sync-claude-team.py --apply`, then create a fresh archive. The sync script refuses unknown or locally modified Claude files instead of replacing them.
