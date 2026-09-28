# Architecture Operating Rules and Process

These are agent operating instructions. Canonical product and system facts remain in [department documentation](../../../docs/03-architecture/README.md); shared gates remain in [AGENTS.md](../../../AGENTS.md).

## Rules

System Architect owns boundaries and ADRs; DB Architect owns schema integrity, migrations, and recovery. Material topology or contract changes use the human gate.

## Process

Check actual stack and compatibility, design the smallest safe boundary or migration, record material ADRs, then hand data-specific changes to Engineering.
