# Data Classification

| Class | Examples | Default handling |
|---|---|---|
| Restricted health | Imported activity/health records, derived load/recovery, sensitive athlete statements | Purpose-limited consent, athlete/authorized-coach scope, minimized export/logging |
| Restricted secrets | Password/session/recovery material, provider tokens, AI/SMTP/storage keys, signing/billing credentials | Secret store or platform-secure storage; never returned or logged |
| Restricted financial | Transactions, refunds, provider evidence, documents, reconciliation | Finance-scoped access, immutable origin, jurisdiction-specific retention |
| Confidential coaching | Coach-private notes, unpublished plans/content | Relationship/scope controlled; excluded from general CRM/admin |
| Confidential CRM/support | Contact data, internal notes, cases, tasks | Minimum fields, role-scoped, safe render/export, retention policy |
| Internal operational | Job state, audit references, metrics without sensitive payload | Least privilege and bounded retention |
| Public/product | Published catalog labels, policy text, released content allowed for display | Rights and version status still apply |

`PD-001` and `PD-003` define accepted product minimization/retention behavior. Legal basis, mandatory retention exceptions, processor contracts, regional transfer mechanism, and marketing consent require specialist/legal approval before release.
