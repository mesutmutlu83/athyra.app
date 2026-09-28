---
name: security-engineering
description: Apply secure-by-design review to authentication, authorization, tenant boundaries, secrets, sensitive data, input/output handling, dependencies, integrations, files, commands, and abuse cases.
---

For behavior-changing security controls, use `regression-safety` to ensure existing protections are not weakened.
Use least privilege and deny-by-default authorization.
For RBAC/multi-tenant systems, use the identity-access-multitenancy skill and explicitly test cross-tenant access, privilege escalation, ownership bypass, and stale/revoked authorization state.
Validate trust boundaries.
Never rely only on client authorization.
Use safe parameterization/encoding.
Review SSRF, path traversal, injection, unsafe deserialization, file upload, command execution, and redirect risks when applicable.
Protect secrets and sensitive logs.
Use established cryptography only.
Review dependency provenance/license/security.
Add negative/abuse tests for security-sensitive behavior.
Escalate auth/privacy/payment/compliance/encryption architecture changes through Human Decision Gate.
