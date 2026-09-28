# System Context

## System responsibility

Sportapp owns user identity mapping, application roles/permissions, profiles, goals, plans, content/catalog versions, imported-record copies and provenance, consent decisions, coach relationships, memberships/entitlements, CRM operations, and auditable decision state.

## External systems

- Apple Health/HealthKit and supported application bridges: read-only existing records.
- Apple and Google identity providers: authentication only; not health permission.
- One initial owner-operated Ollama provider: admin-configured, bounded and consented generation through a provider-neutral server gateway; later non-Ollama adapters require separate approval.
- App Store or another explicitly approved billing provider: authoritative transaction evidence.
- Email/push services: transactional communication only in P0.
- Garmin FIT vocabulary and other licensed sources: build/admin catalog inputs, not device connectivity.

## Trust boundaries

- iPhone and browser clients are untrusted; authorization is server-side.
- Native health-store access occurs on the device, while Sportapp processing consent is server-enforced.
- Admin origin/session is isolated from ordinary user and future coach-web sessions.
- The selected AI provider receives only purpose/recipient/category-authorized and minimized context. Raw health records require PD-003's separate consent and task-bounded category/time-window selection.
- Persistent health/application data is EU-primary in Neon Free Frankfurt and R2 EU. The product owner accepts Cloudflare Workers Free as a global processing boundary, subject to explicit disclosure and approved KVKK cross-border safeguards; no EU-only compute claim is permitted.
- Billing provider evidence is verified before it affects entitlements.
