# Data Flow

## Health/application record flow

External application → native read-only OS/API adapter → account/install/consent-bound idempotent batch → normalization with immutable provenance → authorized summaries → plan/adaptation context.

Sportapp does not write, correct, or delete the source record. Missing or unsupported data remains unknown.

## AI flow

Authenticated task → entitlement and consent check → purpose-limited snapshot → configured Ollama capability/budget check → Ollama adapter → structured generation → schema/semantic/policy validation → proposal → authorized human/limited automation approval → versioned publication. Later providers use the same contract and never activate through silent fallback.

## Billing flow

Verified provider notification/query/client evidence → durable idempotent inbox → financial event → membership/entitlement calculation → user/admin projection → reconciliation. Arrival order is not trusted as event order.

## Admin/CRM flow

MFA staff session → permission and field/scope check → allowlisted action → versioned state change → immutable audit/outbox. Health data, coach-private notes, and secrets are excluded by default.

## Admin-managed configuration/catalog flow

Scoped editor → version-checked draft/change set → typed/referential/capability/compatibility validation → separate publisher step-up + reason + diff → atomic active release → audit/outbox → version-keyed cache invalidation → backend/iOS published snapshot refresh. Validation or publication failure leaves the prior active release unchanged. Mapping changes are prospective; historical reclassification is a separate previewed/audited workflow.
