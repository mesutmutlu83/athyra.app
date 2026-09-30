#!/usr/bin/env bash
set -euo pipefail
umask 077

usage() {
  echo "Usage: $0 --archive FILE [--target-home DIRECTORY] [--project REPOSITORY] [--skip-codex]" >&2
  exit 64
}

archive=""
target_home="${HOME}"
project=""
skip_codex=0
while (($#)); do
  case "$1" in
    --archive) (($# >= 2)) || usage; archive="$2"; shift 2 ;;
    --target-home) (($# >= 2)) || usage; target_home="$2"; shift 2 ;;
    --project) (($# >= 2)) || usage; project="$2"; shift 2 ;;
    --skip-codex) skip_codex=1; shift ;;
    *) usage ;;
  esac
done
[[ -n "$archive" && -f "$archive" ]] || usage
case "$(uname -s)" in
  Darwin|Linux) ;;
  *) echo 'This installer supports macOS and Linux only.' >&2; exit 1 ;;
esac
[[ -d "$target_home" ]] || { echo "Target home does not exist: $target_home" >&2; exit 1; }
target_home="$(cd "$target_home" && pwd -P)"
archive="$(cd "$(dirname "$archive")" && pwd -P)/$(basename "$archive")"
if [[ -n "$project" ]]; then
  [[ -d "$project" ]] || { echo "Project directory does not exist: $project" >&2; exit 1; }
  project="$(cd "$project" && pwd -P)"
fi
if [[ -n "$project" ]] && (( skip_codex )); then
  echo '--project requires Codex CLI; remove --skip-codex.' >&2
  exit 1
fi

# The Python standard library checks every archive entry and digest before any
# destination is changed. A missing Python is an explicit prerequisite here.
command -v python3 >/dev/null || { echo 'Python 3 is required to validate and install the archive.' >&2; exit 1; }
python3 -c 'import sys; sys.exit(sys.version_info < (3, 11))' || {
  echo 'Python 3.11 or newer is required by the shared team validators.' >&2
  exit 1
}

work="$(mktemp -d "${TMPDIR:-/tmp}/portable-codex-team.XXXXXX")"
trap 'rm -rf "$work"' EXIT
cat > "$work/install_payload.py" <<'PY'
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import sys
import tarfile
import tempfile
import tomllib
from datetime import datetime, timezone

archive_path = Path(os.environ['ARCHIVE'])
home = Path(os.environ['TARGET_HOME']).resolve()
sidecar = archive_path.with_name(archive_path.name + '.sha256')
if not sidecar.is_file():
    raise SystemExit(f'Missing checksum file: {sidecar}')
line = sidecar.read_text().strip()
match = re.fullmatch(r'([0-9a-fA-F]{64})  (.+)', line)
if not match or match.group(2) != archive_path.name:
    raise SystemExit('Invalid archive checksum file.')
if archive_path.stat().st_size > 50_000_000:
    raise SystemExit('Archive exceeds the 50 MB safety limit.')
digest = hashlib.sha256()
with archive_path.open('rb') as stream:
    for chunk in iter(lambda: stream.read(1024 * 1024), b''):
        digest.update(chunk)
if digest.hexdigest() != match.group(1).lower():
    raise SystemExit('Archive SHA-256 mismatch.')

def allowed(relative):
    p = PurePosixPath(relative)
    if not relative or p.is_absolute() or p.as_posix() != relative or '\\' in relative or '..' in p.parts or '.' in p.parts:
        return False
    if relative in ('team/README.md', 'codex/AGENTS.md', 'codex/rules/team.rules', 'codex/agents/README.md', 'claude/CLAUDE.md'):
        return True
    if p.parts[:2] in (('team', 'departments'), ('team', 'scripts')) and len(p.parts) >= 3:
        return True
    if p.parts[:3] == ('team', 'templates', 'claude') and len(p.parts) >= 4:
        return True
    if p.parts[:2] == ('codex', 'agents') and len(p.parts) >= 3 and relative.endswith('.toml'):
        return True
    if p.parts[:2] == ('claude', 'agents') and len(p.parts) >= 3 and relative.endswith('.md'):
        return True
    if p.parts[:3] == ('codex', 'skills', 'codebase-memory') and len(p.parts) >= 4:
        return True
    if p.parts[:3] == ('claude', 'skills', 'codebase-memory') and len(p.parts) >= 4:
        return True
    return False

payload = {}
manifest = None
with tarfile.open(archive_path, 'r|gz') as bundle:
    names = set()
    expanded = 0
    for member in bundle:
        if len(names) >= 1000:
            raise SystemExit('Archive contains too many entries.')
        expanded += member.size
        if expanded > 25_000_000:
            raise SystemExit('Archive expands beyond the 25 MB safety limit.')
        if member.name in names or not member.isfile() or member.size > 2_000_000:
            raise SystemExit(f'Unsafe or duplicate archive member: {member.name}')
        names.add(member.name)
        data = bundle.extractfile(member).read()
        if member.name == 'manifest.json':
            manifest = json.loads(data)
        elif member.name.startswith('payload/') and allowed(member.name[8:]):
            payload[member.name[8:]] = data
        else:
            raise SystemExit(f'Unexpected archive path: {member.name}')
if not isinstance(manifest, dict) or manifest.get('format') != 1:
    raise SystemExit('Unsupported or missing manifest.')
files = manifest.get('files')
if not isinstance(files, dict) or set(payload) != set(files):
    raise SystemExit('Archive manifest and payload differ.')
for name, data in payload.items():
    if not allowed(name) or hashlib.sha256(data).hexdigest() != files[name].get('sha256'):
        raise SystemExit(f'Payload integrity check failed: {name}')
    mode = files[name].get('mode')
    if not isinstance(mode, int) or mode < 0 or mode > 0o777:
        raise SystemExit(f'Invalid mode: {name}')
source_home = manifest.get('source_home')
if not isinstance(source_home, str) or not source_home.startswith('/') or source_home == '/':
    raise SystemExit('Invalid source home in manifest.')
roles = manifest.get('roles')
skills = manifest.get('skills')
claude_roles = manifest.get('claude_roles', {})
if not isinstance(roles, dict) or not isinstance(skills, dict):
    raise SystemExit('Invalid role or skill metadata.')
if not isinstance(claude_roles, dict) or (claude_roles and set(claude_roles) != set(roles)):
    raise SystemExit('Invalid Claude role metadata.')
for role, relative in claude_roles.items():
    if not isinstance(relative, str) or not relative.startswith('agents/') or f'claude/{relative}' not in payload:
        raise SystemExit(f'Invalid Claude role mapping: {role}')
if claude_roles and 'claude/CLAUDE.md' not in payload:
    raise SystemExit('Claude team instructions are missing.')

def destination(name):
    p = PurePosixPath(name)
    if p.parts[0] == 'team':
        return home / '.agents/codex-team' / Path(*p.parts[1:])
    if p.parts[0] == 'claude':
        return home / '.claude' / Path(*p.parts[1:])
    return home / '.codex' / Path(*p.parts[1:])

def rebase(data):
    try:
        text = data.decode('utf-8')
    except UnicodeDecodeError:
        return data
    return text.replace(source_home, str(home)).encode('utf-8')

def safe_parent(path):
    relative = path.relative_to(home)
    current = home
    for part in relative.parts[:-1]:
        current /= part
        if current.is_symlink():
            raise SystemExit(f'Symlinked destination parent is unsafe: {current}')

receipt_path = home / '.agents/codex-team/.portable-install.json'
safe_parent(receipt_path)
if receipt_path.is_symlink() or (receipt_path.exists() and not receipt_path.is_file()):
    raise SystemExit(f'Unsafe install receipt path: {receipt_path}')

writes = {}
for name, data in payload.items():
    target = destination(name)
    safe_parent(target)
    writes[target] = (rebase(data), files[name]['mode'])

team_ag = home / '.codex/AGENTS.md'
start = '<!-- portable-codex-team:start -->'
end = '<!-- portable-codex-team:end -->'
team_text = writes.pop(team_ag)[0].decode('utf-8').strip() + '\n'
current = ''
if team_ag.exists():
    if team_ag.is_symlink() or not team_ag.is_file():
        raise SystemExit(f'Conflicting global instruction file: {team_ag}')
    current = team_ag.read_text()
    # The Codebase Memory installer may already have placed its own marker.
    # Keep that existing block and avoid inserting a second copy.
    outside_managed = current
    if start in current and end in current:
        outside_managed = current.split(start, 1)[0] + current.split(end, 1)[1]
    if '<!-- codebase-memory-mcp:start -->' in outside_managed:
        team_text = re.sub(r'<!-- codebase-memory-mcp:start -->.*?<!-- codebase-memory-mcp:end -->\s*', '', team_text, flags=re.S)
managed_block = f'{start}\n{team_text}{end}\n'
if team_ag.exists():
    if start in current or end in current:
        if current.count(start) != 1 or current.count(end) != 1 or current.index(start) > current.index(end):
            raise SystemExit('Malformed managed block in target AGENTS.md.')
        before, rest = current.split(start, 1)
        old_block, after = rest.split(end, 1)
        old_receipt = json.loads(receipt_path.read_text()) if receipt_path.is_file() else {}
        old_digest = old_receipt.get('managed_agents_sha256')
        if old_digest and hashlib.sha256((start + old_block + end).encode()).hexdigest() != old_digest:
            raise SystemExit('Existing managed AGENTS.md block was customized; merge it manually.')
        if not old_digest and (start + old_block + end).strip() != managed_block.strip():
            raise SystemExit('Existing managed AGENTS.md block has unknown provenance.')
        result = before + managed_block + after.lstrip('\n')
    elif current.strip() == team_text.strip():
        result = current
    elif '# Codex Software Team Operating System' in current:
        raise SystemExit('Target AGENTS.md has unmarked team instructions; merge them manually once.')
    else:
        result = current.rstrip() + '\n\n' + managed_block
else:
    result = managed_block
writes[team_ag] = (result.encode(), 0o644)

# Merge only team role registrations, preserving every unrelated config entry.
config_path = home / '.codex/config.toml'
safe_parent(config_path)
if config_path.exists() and (config_path.is_symlink() or not config_path.is_file()):
    raise SystemExit(f'Conflicting config file: {config_path}')
config = config_path.read_text() if config_path.exists() else ''
try:
    parsed_config = tomllib.loads(config)
except tomllib.TOMLDecodeError as error:
    raise SystemExit(f'Target Codex config is not valid TOML: {error}')
tables = set(re.findall(r'^\[([^\]\n]+)\]\s*$', config, re.M))
addition = ''
if 'agents' not in parsed_config:
    addition += '\n[agents]\nenabled = true\nmax_concurrent_threads_per_session = 4\n'
for role, registration in sorted(roles.items()):
    if not re.fullmatch(r'[a-z][a-z0-9_-]*', role) or not isinstance(registration, dict):
        raise SystemExit(f'Invalid role metadata: {role}')
    rel = registration.get('config_file')
    description = registration.get('description')
    if not isinstance(rel, str) or not rel.startswith('agents/') or f'codex/{rel}' not in payload or not isinstance(description, str):
        raise SystemExit(f'Invalid role mapping: {role}')
    table = 'agents.' + role
    if table in tables:
        pattern = rf'^\[{re.escape(table)}\]\s*$([\s\S]*?)(?=^\[|\Z)'
        block = re.search(pattern, config, re.M)
        existing = re.search(r'^config_file\s*=\s*"([^"\n]+)"\s*$', block.group(1), re.M) if block else None
        if not existing or existing.group(1) != rel:
            raise SystemExit(f'Conflicting existing agent registration: {role}')
        continue
    addition += f'\n[{table}]\ndescription = {json.dumps(description)}\nconfig_file = {json.dumps(rel)}\n'
if addition:
    config = config.rstrip() + '\n' + addition
try:
    tomllib.loads(config)
except tomllib.TOMLDecodeError as error:
    raise SystemExit(f'Merged Codex config would be invalid TOML: {error}')
writes[config_path] = (config.encode(), 0o600)

if claude_roles:
    claude_settings_path = home / '.claude/settings.json'
    safe_parent(claude_settings_path)
    if claude_settings_path.exists() and (claude_settings_path.is_symlink() or not claude_settings_path.is_file()):
        raise SystemExit(f'Conflicting Claude settings file: {claude_settings_path}')
    try:
        claude_settings = json.loads(claude_settings_path.read_text()) if claude_settings_path.exists() else {}
    except json.JSONDecodeError as error:
        raise SystemExit(f'Target Claude settings are not valid JSON: {error}')
    if not isinstance(claude_settings, dict):
        raise SystemExit('Target Claude settings must be a JSON object.')
    plugin_configs = claude_settings.setdefault('pluginConfigs', {})
    if not isinstance(plugin_configs, dict):
        raise SystemExit('Target Claude pluginConfigs must be an object.')
    agents_md = plugin_configs.setdefault('agents-md@builtin', {})
    if not isinstance(agents_md, dict):
        raise SystemExit('Target Claude agents-md configuration must be an object.')
    options = agents_md.setdefault('options', {})
    if not isinstance(options, dict) or options.get('instructionFiles') not in (None, 'claude-md-and-agents-md'):
        raise SystemExit('Target Claude instructionFiles setting conflicts with project AGENTS.md support.')
    options['instructionFiles'] = 'claude-md-and-agents-md'
    writes[claude_settings_path] = ((json.dumps(claude_settings, indent=2, ensure_ascii=False) + '\n').encode(), 0o600)
    claude_sync_files = {'CLAUDE.md': hashlib.sha256(writes[home / '.claude/CLAUDE.md'][0]).hexdigest()}
    for relative in claude_roles.values():
        target = home / '.claude' / relative
        if '<!-- managed by sync-claude-team.py;' in writes[target][0].decode('utf-8'):
            claude_sync_files[relative] = hashlib.sha256(writes[target][0]).hexdigest()
    claude_sync_manifest = home / '.claude/team-sync-manifest.json'
    safe_parent(claude_sync_manifest)
    writes[claude_sync_manifest] = ((json.dumps({'format': 1, 'files': claude_sync_files}, indent=2, sort_keys=True) + '\n').encode(), 0o600)

links = {}
for skill, rel in skills.items():
    if not re.fullmatch(r'[a-z][a-z0-9-]*', skill) or not isinstance(rel, str):
        raise SystemExit(f'Invalid skill mapping: {skill}')
    if f'team/{rel}/SKILL.md' not in payload:
        raise SystemExit(f'Skill file missing from payload: {skill}')
    path = home / '.agents/skills' / skill
    safe_parent(path)
    target = home / '.agents/codex-team' / rel
    if path.is_symlink():
        if path.resolve() != target:
            raise SystemExit(f'Conflicting existing skill link: {path}')
    elif path.exists():
        raise SystemExit(f'Conflicting existing skill path: {path}')
    else:
        links[path] = target
    if claude_roles:
        claude_path = home / '.claude/skills' / skill
        safe_parent(claude_path)
        if claude_path.is_symlink():
            if claude_path.resolve() != target:
                raise SystemExit(f'Conflicting existing Claude skill link: {claude_path}')
        elif claude_path.exists():
            raise SystemExit(f'Conflicting existing Claude skill path: {claude_path}')
        else:
            links[claude_path] = target

# Existing modified files are never silently replaced. A previous install
# manifest permits safe upgrades only when the old file is unchanged.
receipt = receipt_path
previous = json.loads(receipt.read_text()) if receipt.is_file() else {}
previous_files = previous.get('installed_sha256', {})
# Older bundles put these three profiles at the agents root. Remove only an
# unchanged profile owned by a prior portable install (or an exact copy of the
# incoming profile), and keep a backup so an upgrade cannot leave duplicates.
legacy_removals = []
for name in ('codebase-memory.toml', 'codebase-memory-scout.toml',
             'codebase-memory-auditor.toml'):
    new_path = home / '.codex/agents/engineering' / name
    old_path = home / '.codex/agents' / name
    if new_path not in writes:
        continue
    for role_name, role_config in parsed_config.get('agents', {}).items():
        configured_file = role_config.get('config_file') if isinstance(role_config, dict) else None
        if not isinstance(configured_file, str):
            continue
        configured_path = Path(configured_file)
        if not configured_path.is_absolute():
            configured_path = home / '.codex' / configured_path
        if os.path.normpath(str(configured_path)) == os.path.normpath(str(old_path)):
            raise SystemExit(
                f'Existing agent registration {role_name} still points to legacy Codebase Memory profile: {old_path}'
            )
    safe_parent(old_path)
    if old_path.is_symlink() or (old_path.exists() and not old_path.is_file()):
        raise SystemExit(f'Unsafe legacy Codebase Memory profile: {old_path}')
    if old_path.is_file():
        existing = old_path.read_bytes()
        owned_hash = previous_files.get(str(old_path.relative_to(home)))
        if owned_hash != hashlib.sha256(existing).hexdigest() and existing != writes[new_path][0]:
            raise SystemExit(f'Customized legacy Codebase Memory profile needs manual merge: {old_path}')
        legacy_removals.append(old_path)
for name in ('codebase-memory.md', 'codebase-memory-scout.md',
             'codebase-memory-auditor.md'):
    new_path = home / '.claude/agents/engineering' / name
    old_path = home / '.claude/agents' / name
    if new_path not in writes:
        continue
    safe_parent(old_path)
    if old_path.is_symlink() or (old_path.exists() and not old_path.is_file()):
        raise SystemExit(f'Unsafe legacy Claude Codebase Memory profile: {old_path}')
    if old_path.is_file():
        existing = old_path.read_bytes()
        owned_hash = previous_files.get(str(old_path.relative_to(home)))
        if owned_hash != hashlib.sha256(existing).hexdigest() and existing != writes[new_path][0]:
            raise SystemExit(f'Customized legacy Claude Codebase Memory profile needs manual merge: {old_path}')
        legacy_removals.append(old_path)
changes = {}
for path, (data, mode) in writes.items():
    if path.exists():
        if path.is_symlink() or not path.is_file():
            raise SystemExit(f'Conflicting destination: {path}')
        existing = path.read_bytes()
        if existing == data:
            continue
        merged_configs = (team_ag, config_path, home / '.claude/settings.json')
        if path not in merged_configs and previous_files.get(str(path.relative_to(home))) != hashlib.sha256(existing).hexdigest():
            raise SystemExit(f'Existing customized file needs manual merge: {path}')
    changes[path] = (data, mode)

if os.environ.get('VALIDATE_ONLY') == '1':
    print(f'Archive preflight passed: {len(roles)} roles, {len(skills)} team skills, {len(payload)} files')
    sys.exit(0)

backup = home / '.agents/codex-team-backups' / ('install-' + datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
safe_parent(backup)
if backup.is_symlink() or backup.exists():
    raise SystemExit(f'Unsafe backup destination: {backup}')
if changes or links or legacy_removals:
    backup.mkdir(parents=True, exist_ok=False)
created = []
restored = {}
try:
    for path, (data, mode) in changes.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        if path.exists():
            old = backup / path.relative_to(home)
            old.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, old)
            restored[path] = old
        else:
            created.append(path)
        fd, temp_name = tempfile.mkstemp(prefix='.portable-', dir=path.parent)
        try:
            with os.fdopen(fd, 'wb') as stream:
                stream.write(data)
            os.chmod(temp_name, mode)
            os.replace(temp_name, path)
        finally:
            if os.path.exists(temp_name):
                os.unlink(temp_name)
    for path, target in links.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.symlink_to(target)
        created.append(path)
    for path in legacy_removals:
        old = backup / path.relative_to(home)
        old.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, old)
        restored[path] = old
        path.unlink()
    receipt.parent.mkdir(parents=True, exist_ok=True)
    receipt_data = {'format': 1, 'installed_sha256': {
        str(path.relative_to(home)): hashlib.sha256(data).hexdigest()
        for path, (data, _) in writes.items()},
        'managed_agents_sha256': hashlib.sha256(managed_block.strip().encode()).hexdigest(),
        'roles': sorted(roles), 'skills': sorted(skills), 'claude_roles': sorted(claude_roles)}
    receipt_text = json.dumps(receipt_data, indent=2, sort_keys=True) + '\n'
    if not receipt.is_file() or receipt.read_text() != receipt_text:
        if not backup.exists():
            backup.mkdir(parents=True, exist_ok=False)
        if receipt.is_file():
            old = backup / receipt.relative_to(home)
            old.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(receipt, old)
        fd, receipt_temp = tempfile.mkstemp(prefix='.portable-receipt-', dir=receipt.parent)
        try:
            with os.fdopen(fd, 'w') as stream:
                stream.write(receipt_text)
            os.chmod(receipt_temp, 0o600)
            os.replace(receipt_temp, receipt)
        finally:
            if os.path.exists(receipt_temp):
                os.unlink(receipt_temp)
except Exception:
    for path in reversed(created):
        path.unlink(missing_ok=True)
    for path, old in restored.items():
        shutil.copy2(old, path)
    raise

print(f'Installed {len(roles)} Codex roles, {len(claude_roles)} Claude roles, and {len(skills)} shared skills into {home}')
print(f'Backup of changed existing files: {backup if backup.exists() else "none (already current)"}')
if '[agents]' in config and re.search(r'^\[agents\]\s*$\n(?:[^\[]*?)^enabled\s*=\s*false\s*$', config, re.M):
    print('Note: target config has agents disabled; preserved that existing setting.', file=sys.stderr)
PY

ARCHIVE="$archive" TARGET_HOME="$target_home" VALIDATE_ONLY=1 python3 "$work/install_payload.py"

if (( ! skip_codex )); then
  [[ "$target_home" == "$(cd "$HOME" && pwd -P)" ]] || {
    echo 'Codex CLI installation for an alternate --target-home requires --skip-codex.' >&2
    exit 1
  }
  if ! command -v codex >/dev/null 2>&1; then
    command -v curl >/dev/null || { echo 'curl is required for the official Codex installer.' >&2; exit 1; }
    codex_work="$(mktemp -d "${TMPDIR:-/tmp}/codex-installer.XXXXXX")"
    trap 'rm -rf "$work" "$codex_work"' EXIT
    # Official OpenAI installer: https://learn.chatgpt.com/docs/codex/cli
    # Download to a file and syntax-check before execution; never pipe to sh.
    curl --proto '=https' --tlsv1.2 -fsSL https://chatgpt.com/codex/install.sh -o "$codex_work/install.sh"
    sh -n "$codex_work/install.sh"
    sh "$codex_work/install.sh"
    export PATH="$HOME/.local/bin:$PATH"
    command -v codex >/dev/null || { echo 'Codex installed but is not on PATH. Add ~/.local/bin to PATH and retry.' >&2; exit 1; }
  fi
  codex --version
fi

ARCHIVE="$archive" TARGET_HOME="$target_home" python3 "$work/install_payload.py"

if [[ -n "$project" ]]; then
  CODEX_HOME="$target_home/.codex" HOME="$target_home" \
    "$target_home/.agents/codex-team/scripts/setup-codebase-memory.sh" --root "$project"
  if command -v claude >/dev/null 2>&1; then
    if python3 - "$target_home" <<'PY'
import json
from pathlib import Path
import sys

home = Path(sys.argv[1])
config = home / '.claude.json'
if config.is_symlink():
    raise SystemExit(f'Refusing symlinked Claude user configuration: {config}')
try:
    data = json.loads(config.read_text()) if config.is_file() else {}
except (OSError, json.JSONDecodeError) as error:
    raise SystemExit(f'Cannot verify Claude MCP user configuration: {error}')
if not isinstance(data, dict) or not isinstance(data.get('mcpServers', {}), dict):
    raise SystemExit('Invalid Claude user MCP configuration shape.')
server = data.get('mcpServers', {}).get('codebase-memory-mcp')
if server is None:
    raise SystemExit(2)
expected = str(home / '.local/bin/codebase-memory-mcp')
if not isinstance(server, dict) or server.get('command') != expected or server.get('args', []) != [] or server.get('type', 'stdio') != 'stdio':
    raise SystemExit('Existing Claude user-scoped Codebase Memory MCP has a different command or arguments; reconcile it manually.')
print('Claude user-scoped Codebase Memory MCP command verified.')
PY
    then
      :
    else
      mcp_check=$?
      if (( mcp_check != 2 )); then
        exit "$mcp_check"
      fi
      claude mcp add --scope user codebase-memory-mcp -- "$target_home/.local/bin/codebase-memory-mcp"
    fi
  else
    echo 'Claude CLI is absent; install it and register Codebase Memory with the command in README.md.'
  fi
fi

echo 'Portable team installation complete. Run codex login on this computer before first use.'
