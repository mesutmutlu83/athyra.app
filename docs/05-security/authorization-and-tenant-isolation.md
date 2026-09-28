# Authorization and Tenant Isolation Security Baseline

## Non-negotiable
- Server-side authorization for protected operations.
- Deny by default.
- Validate tenant membership and scope.
- Validate resource tenant/ownership.
- No trust in client role/permission/tenant claims without server validation.
- No secret or privileged credential embedded in web/mobile clients.

## Review checklist
- IDOR / object-level authorization.
- Function-level authorization.
- Cross-tenant read/write/delete/export.
- Role assignment privilege escalation.
- Admin/delegation boundaries.
- Membership suspension/removal.
- Token/claim staleness and revocation.
- Cache/search/object-storage tenant keys.
- Background jobs and async tenant context.
- Logs/analytics with tenant data.
- Bulk APIs and filters.
- File download/upload authorization.
- Websocket/subscription authorization.
