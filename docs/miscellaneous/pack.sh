#!/usr/bin/env bash
set -euo pipefail
umask 077

usage() {
  echo "Usage: $0 [--output FILE] [--source-home DIRECTORY]" >&2
  exit 64
}

source_home="${HOME}"
output=""
while (($#)); do
  case "$1" in
    --source-home) (($# >= 2)) || usage; source_home="$2"; shift 2 ;;
    --output) (($# >= 2)) || usage; output="$2"; shift 2 ;;
    *) usage ;;
  esac
done
source_home="$(cd "$source_home" && pwd -P)"
if [[ -z "$output" ]]; then
  output="$(pwd)/codex-team-portable-$(date +%Y%m%d-%H%M%S).tar.gz"
fi
mkdir -p "$(dirname "$output")"
output="$(cd "$(dirname "$output")" && pwd -P)/$(basename "$output")"
[[ ! -e "$output" && ! -L "$output" && ! -e "${output}.sha256" && ! -L "${output}.sha256" ]] || {
  echo "Output archive or checksum file already exists: $output" >&2
  exit 1
}
command -v python3 >/dev/null || { echo 'Python 3 is required to create the verified archive.' >&2; exit 1; }
python3 -c 'import sys; sys.exit(sys.version_info < (3, 11))' || {
  echo 'Python 3.11 or newer is required by the shared team validators.' >&2
  exit 1
}

SOURCE_HOME="$source_home" BUNDLE_OUTPUT="$output" python3 - <<'PY'
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tarfile
import tempfile

home = Path(os.environ['SOURCE_HOME']).resolve()
output = Path(os.environ['BUNDLE_OUTPUT'])
team = home / '.agents/codex-team'
codex = home / '.codex'
claude = home / '.claude'
required = [team / 'departments', team / 'scripts', team / 'README.md',
            team / 'templates/claude/CLAUDE.md', claude / 'CLAUDE.md',
            codex / 'AGENTS.md', codex / 'config.toml', codex / 'rules/team.rules',
            codex / 'agents/README.md']
for path in required:
    if not path.exists():
        raise SystemExit(f'Missing shared-team source: {path}')
subprocess.run([sys.executable, str(team / 'scripts/sync-claude-team.py'),
                '--home', str(home), '--check'], check=True)

payload = {}
credential_pattern = re.compile(rb'(?:sk-|ghp_|github_pat_)[A-Za-z0-9_-]{20,}|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----')
private_name = re.compile(r'(?:credential|secret|token|private|password|session|cookie|wallet|account|auth|\.env)', re.I)
def generated_metadata(path):
    return (path.name == '.DS_Store' or path.name.startswith('._')
            or '__pycache__' in path.parts or path.suffix == '.pyc')

def add_file(source, destination):
    if source.is_symlink() or not source.is_file():
        raise SystemExit(f'Expected a regular file: {source}')
    if source.name in ('id_rsa', 'id_ed25519') or private_name.search(source.name):
        raise SystemExit(f'Unexpected private file in shared-team source: {source}')
    if source.suffix.lower() not in ('.md', '.json', '.py', '.sh', '.pl', '.plist', '.toml', '.rules'):
        raise SystemExit(f'Unexpected file type in shared-team source: {source}')
    data = source.read_bytes()
    if len(data) > 2_000_000:
        raise SystemExit(f'Shared-team file is unexpectedly large: {source}')
    if destination in payload:
        raise SystemExit(f'Duplicate bundle path: {destination}')
    if credential_pattern.search(data):
        raise SystemExit(f'Possible credential in {source}; archive not written.')
    payload[destination] = (data, source.stat().st_mode & 0o777)

for base, prefix in ((team / 'departments', 'team/departments'),
                     (team / 'scripts', 'team/scripts'),
                     (team / 'templates/claude', 'team/templates/claude')):
    for source in sorted(base.rglob('*')):
        if source.is_dir():
            continue
        if generated_metadata(source):
            continue
        add_file(source, f'{prefix}/{source.relative_to(base).as_posix()}')
add_file(team / 'README.md', 'team/README.md')
if (codex / 'AGENTS.md').is_symlink():
    raise SystemExit('Global AGENTS.md must be a regular file.')
global_agents = (codex / 'AGENTS.md').read_text()
source_start = '<!-- portable-codex-team:source-start -->'
source_end = '<!-- portable-codex-team:source-end -->'
installed_start = '<!-- portable-codex-team:start -->'
installed_end = '<!-- portable-codex-team:end -->'
available = []
for start, end in ((source_start, source_end), (installed_start, installed_end)):
    if start in global_agents or end in global_agents:
        if global_agents.count(start) != 1 or global_agents.count(end) != 1 or global_agents.index(start) > global_agents.index(end):
            raise SystemExit('Global AGENTS.md has a malformed portable team block.')
        available.append((start, end))
if len(available) != 1:
    raise SystemExit('Global AGENTS.md needs exactly one marked portable team block.')
start, end = available[0]
team_instructions = global_agents.split(start, 1)[1].split(end, 1)[0].strip() + '\n'
if len(team_instructions.encode()) > 2_000_000 or credential_pattern.search(team_instructions.encode()):
    raise SystemExit('Marked team AGENTS.md block is too large or contains a possible credential.')
payload['codex/AGENTS.md'] = (team_instructions.encode(), 0o644)
add_file(codex / 'rules/team.rules', 'codex/rules/team.rules')
add_file(codex / 'agents/README.md', 'codex/agents/README.md')

for name in ('codebase-memory.toml', 'codebase-memory-scout.toml',
             'codebase-memory-auditor.toml'):
    legacy = codex / 'agents' / name
    if legacy.exists() or legacy.is_symlink():
        raise SystemExit(f'Legacy root-level Codebase Memory profile must be reconciled before packing: {legacy}')

# A department README is the ownership inventory. An unrelated user profile
# under ~/.codex/agents is never exported simply because of its directory.
team_roles = set()
for readme in sorted((team / 'departments').glob('*/README.md')):
    department = readme.parent.name
    for relative in re.findall(r'\.codex/agents/([a-z0-9-]+/[a-z0-9-]+\.toml)', readme.read_text()):
        if relative.split('/', 1)[0] != department:
            raise SystemExit(f'Cross-department role link in {readme}: {relative}')
        if not (codex / 'agents' / relative).is_file():
            raise SystemExit(f'Department role link is missing: {relative}')
        team_roles.add(relative)
if not team_roles:
    raise SystemExit('No department-owned role links were found.')
for relative in sorted(team_roles):
    source = codex / 'agents' / relative
    add_file(source, f'codex/agents/{relative}')

cbm_skill = codex / 'skills/codebase-memory'
if cbm_skill.is_dir():
    for source in sorted(cbm_skill.rglob('*')):
        if source.is_dir():
            continue
        if generated_metadata(source):
            continue
        add_file(source, f'codex/skills/codebase-memory/{source.relative_to(cbm_skill).as_posix()}')

skills = {}
skill_dir = home / '.agents/skills'
for link in sorted(skill_dir.iterdir()):
    if not link.is_symlink():
        continue
    target = link.resolve()
    try:
        rel = target.relative_to(team).as_posix()
    except ValueError:
        continue
    if not (target / 'SKILL.md').is_file():
        continue
    if f'team/{rel}/SKILL.md' not in payload:
        raise SystemExit(f'Skill target is missing from bundle: {link}')
    skills[link.name] = rel
if not skills:
    raise SystemExit('No shared-team skill links were found.')

config = (codex / 'config.toml').read_text()
sections = re.split(r'(?=^\[agents\.[A-Za-z0-9_-]+\]\s*$)', config, flags=re.M)
registrations = {}
for section in sections[1:]:
    first = section.splitlines()[0]
    name = re.fullmatch(r'\[agents\.([A-Za-z0-9_-]+)\]', first.strip())
    if not name:
        continue
    # Stop at the next TOML table, including non-agent sections.
    body = []
    for line in section.splitlines()[1:]:
        if line.startswith('['):
            break
        body.append(line)
    block = '\n'.join(body)
    match = re.search(r'^config_file\s*=\s*"(agents/[^"\n]+\.toml)"\s*$', block, re.M)
    if not match:
        continue
    rel = match.group(1)
    if rel[len('agents/'):] not in team_roles:
        continue  # unrelated personal registration
    description = re.search(r'^description\s*=\s*("(?:[^"\\]|\\.)*")\s*$', block, re.M)
    if not description:
        raise SystemExit(f'Registered role lacks a description: {name.group(1)}')
    description_text = json.loads(description.group(1))
    if len(description_text) > 1000 or credential_pattern.search(description_text.encode()):
        raise SystemExit(f'Unsafe registered role description: {name.group(1)}')
    registrations[name.group(1)] = {'config_file': rel,
                                    'description': description_text}
if not registrations:
    raise SystemExit('No registered team roles were found.')
if {entry['config_file'][len('agents/'):] for entry in registrations.values()} != team_roles:
    raise SystemExit('Department role links and team agent registrations differ.')

# Export only Claude profiles that correspond to registered team roles. Other
# personal Claude agents, settings, plugins, auth and host caches remain local.
claude_roles = {}
for name, registration in sorted(registrations.items()):
    source_role = registration['config_file'][len('agents/'):]
    department, filename = source_role.split('/', 1)
    relative = f'agents/{department}/{Path(filename).stem}.md'
    source = claude / relative
    if source.is_symlink() or not source.is_file():
        raise SystemExit(f'Missing or linked Claude team role: {source}')
    match = re.search(r'^name:\s*(.+?)\s*$', source.read_text(), re.M)
    if not match:
        raise SystemExit(f'Claude team role lacks a name: {source}')
    raw_name = match.group(1)
    found_name = json.loads(raw_name) if raw_name.startswith('"') else raw_name
    if found_name != name:
        raise SystemExit(f'Claude role name differs from Codex registration: {source}')
    add_file(source, f'claude/{relative}')
    claude_roles[name] = relative
add_file(claude / 'CLAUDE.md', 'claude/CLAUDE.md')
cbm_claude_skill = claude / 'skills/codebase-memory'
if cbm_claude_skill.is_dir():
    for source in sorted(cbm_claude_skill.rglob('*')):
        if source.is_dir() or generated_metadata(source):
            continue
        add_file(source, f'claude/skills/codebase-memory/{source.relative_to(cbm_claude_skill).as_posix()}')

if sum(len(data) for data, _ in payload.values()) > 25_000_000:
    raise SystemExit('Shared-team payload exceeds the 25 MB safety limit.')

entries = {name: {'sha256': hashlib.sha256(data).hexdigest(), 'mode': mode}
           for name, (data, mode) in payload.items()}
manifest = {'format': 1, 'source_home': str(home), 'files': entries,
            'roles': registrations, 'skills': skills, 'claude_roles': claude_roles,
            'note': 'Shared team only; no auth, MCP account settings, project state or schedules.'}
raw_manifest = json.dumps(manifest, indent=2, sort_keys=True).encode() + b'\n'
fd, temporary_name = tempfile.mkstemp(prefix='.portable-team-', suffix='.partial', dir=output.parent)
os.close(fd)
temporary = Path(temporary_name)
published = False
try:
    with tarfile.open(temporary, 'w:gz', format=tarfile.PAX_FORMAT) as archive:
        for name, (data, mode) in sorted(payload.items()):
            info = tarfile.TarInfo(f'payload/{name}')
            info.size = len(data)
            info.mode = mode
            archive.addfile(info, io.BytesIO(data))
        info = tarfile.TarInfo('manifest.json')
        info.size = len(raw_manifest)
        info.mode = 0o600
        archive.addfile(info, io.BytesIO(raw_manifest))
    digest = hashlib.sha256(temporary.read_bytes()).hexdigest()
    os.link(temporary, output)  # exclusive publication: existing path is never replaced
    published = True
    with output.with_name(output.name + '.sha256').open('x') as stream:
        stream.write(f'{digest}  {output.name}\n')
except Exception:
    if published:
        output.unlink()
    raise
finally:
    temporary.unlink(missing_ok=True)
print(f'Created {output} ({len(registrations)} roles, {len(skills)} shared skills, {len(payload)} files)')
print(f'SHA-256: {digest}')
print(f'Checksum file: {output}.sha256')
PY
