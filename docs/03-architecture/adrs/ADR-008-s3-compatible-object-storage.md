# ADR-008: Configurable S3-Compatible Object Storage

- Status: Accepted with implementation/migration validation
- Date: 2026-09-25
- Decision owner: Product owner
- Related feature(s): FEAT-001

## Decision

Use Cloudflare R2 with EU jurisdiction as the default object store. Access it through an application-owned S3-compatible provider interface. Authorized owners can configure a reviewed provider instance in the private admin panel using endpoint, region, bucket, addressing/signing options and write-only credentials protected under ADR-009, then run a constrained connection test.

Every stored-object record retains provider-instance ID, bucket, immutable object key, size, content type and checksum. Switching the active provider changes new writes only. Reads continue through each object's recorded provider. Existing objects move only through an explicit, resumable, checksum-verified migration with audit evidence and rollback.

## Guardrails

- Arbitrary endpoints are not enabled merely by saving a URL; endpoint schemes, redirects, DNS resolution and egress targets are validated against an approved provider policy.
- Credentials are write-only, least-privileged, environment-scoped and envelope-encrypted under ADR-009.
- Private objects use short-lived authorized access; public bucket access is off by default.
- EU residency claims apply only to providers/buckets whose jurisdiction has been verified.
- Provider deletion is blocked while live objects still reference it.

Compatible alternatives such as AWS S3, Backblaze B2, Wasabi or owner-operated MinIO may be added after compatibility, security, privacy and operations review.
