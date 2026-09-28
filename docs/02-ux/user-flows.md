# Global User Flows

## Athlete first-run

Welcome and policies → email/Apple/Google identity → account/terms → athlete/coach role selection → goals, sport-specific experience, availability, equipment → optionally connect a data source or skip → separately choose AI recipient/connection and consent → generate, validate, review, and approve the first weekly plan.

## Ongoing athlete loop

Open Today/Week → view recommendation and provenance/freshness → follow guidance without in-app recording → import an external record or submit a user report → receive a proposed adaptation → review differences → approve or reject.

## Coach loop

Authenticate in the same native app → select an explicitly authorized athlete → review scoped history → draft/edit a plan → review AI proposal → publish under the active-authority rule → manage access without taking ownership of athlete history.

## Admin/support loop

Invitation + MFA → role-scoped dashboard → narrow user/membership/CRM record → perform allowlisted action with reason/step-up when required → immutable audit. User-visible replies and internal notes remain separate.

## Admin configuration/catalog release loop

Scoped editor opens Metadata, Content, Integrations or Configuration → creates versioned draft/change set → validates and resolves typed/capability/compatibility errors → separate publisher reviews diff/impact → step-up + reason + confirm → atomic publish → verification/history; rollback selects a prior valid release and repeats protected publish controls. Drafts never appear in app/backend published snapshots.

## Billing loop

Only when BILLING-001 enables a channel: show provider-authoritative product/price → official purchase flow → server verification → membership/entitlement update → reconciliation. Account, role, payment, entitlement, and consent never collapse into one state.
