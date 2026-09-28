# Test Matrix

| Area | Required evidence | Critical risks |
|---|---|---|
| Identity/account | Unit + provider contract + native/admin E2E | takeover, collision, replay, wrong account |
| Consent/health import | Policy + integration + physical-device/source test | wrong scope/account, stale permission, invented data |
| Planning/adaptation | Deterministic validators + scenario/eval + coach review | unsafe/infeasible plan, stale publication, unsupported sport |
| Catalog | Import completeness/hash + mapping/review + API/UI | rights, data loss, version drift, false coaching maturity |
| AI gateway | Schema/policy + endpoint security + provider capability tests | secret leak, SSRF, silent fallback, cross-user context |
| Admin/RBAC/CRM | API authorization + browser E2E + negative security | privilege escalation, XSS/CSRF, health leakage |
| Billing/entitlement | Provider contract/sandbox + races/reconciliation | forged/duplicate/late event, wrong account/currency |
| Lifecycle/export/delete | Integration + recovery + authorization | resurrection, over-retention, leaked download |
| Compatibility/release | CI builds + simulator + physical devices + archive | unsupported OS claim, dependency minimum drift |
