# Requirement Traceability

The source brief at `docs/01-product/project-brief.md` is the authoritative imported requirement inventory: 230 feature requirements and 220 acceptance scenarios. No scenario has execution evidence yet.

Implementation backlog must map each work item as:

`task_id → feature_ids → acceptance criteria → automated/manual test IDs → environment/artifact → result/date`

Initial release synthesis is maintained under `docs/features/FEAT-001-initial-release/`. It summarizes the program but does not replace the source IDs or permit omitted P0 requirements.

The accepted admin-managed metadata/configuration delta is maintained under `docs/features/FEAT-002-admin-managed-metadata-config/`. Its `AMC-*` requirements and `TAX/INT/CFG/SEC/REG` test families extend, but do not renumber or overwrite, the v6 source inventory. Implementation evidence must preserve the same task-to-requirement-to-test chain.
