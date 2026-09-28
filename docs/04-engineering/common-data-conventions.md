# Common Data Conventions

These are defaults for persistent application data. Adapt them to the real stack and domain.

## Identity and IDs
- Use stable primary keys appropriate to the DB/architecture.
- Public identifiers are not security boundaries.
- Do not expose sequential IDs solely when doing so creates an actual product/security concern; authorization is still mandatory.

## Tenant ownership
- Tenant-owned data should have an enforceable tenant relationship.
- Tenant scope should participate in indexes and unique constraints when query/uniqueness semantics are tenant-local.

## Timestamps
- Use unambiguous canonical timestamps.
- Store/display timezone semantics explicitly.
- Do not persist locale-formatted timestamps as domain values.

## Lifecycle/status
- Prefer explicit lifecycle status when there are more than two meaningful states.
- Avoid a collection of contradictory booleans for state machines.

## Audit metadata
Use `created_at`, `updated_at`, actor fields, version fields, or history only when the domain/operational need justifies them. Do not cargo-cult every column into every table.

## Delete/retention
- Do not automatically use soft delete everywhere.
- Use soft delete when recovery/history/product rules require it.
- Define hard-delete/anonymization/retention for sensitive data.
- Unique constraints and foreign keys must account for delete semantics.

## JSON/blob fields
- Do not use JSON/blob columns to bypass real relational constraints for core entities/RBAC.
- JSON is acceptable for truly flexible or opaque payloads when query/integrity needs support it.

## Derived state
- Caches, search indexes, permission summaries and materialized views are derived unless explicitly designed otherwise.
- Define rebuild/invalidation behavior.
