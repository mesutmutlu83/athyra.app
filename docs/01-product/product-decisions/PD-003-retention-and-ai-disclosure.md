# PD-003 — Retention and Raw Health AI Disclosure

- Status: Accepted with legal gate
- Decision date: 2026-09-25
- Decision owner: Product owner

The retention targets in `PD-001` are accepted product behavior. Final legal bases, notices, international-transfer mechanism, processor contracts and mandatory financial retention remain subject to qualified Turkish/EU legal review.

Raw health records may be disclosed to an approved AI provider only when all of the following hold:

- the user has given separate, versioned, explicit consent for the named purpose and the effective provider instance/recipient policy version;
- only the required data categories and bounded time window for that task are selected;
- the provider has passed health-data eligibility, region/transfer, DPA, retention, training-use and subprocessors review;
- application and provider logging exclude payloads, and the provider does not train on the data unless separately and expressly approved;
- the authoritative consent/version is rechecked immediately before provider dispatch; revocation prevents new dispatch and cancelled queued work cannot call the provider;
- the UI explains that already transmitted data cannot be technically recalled from a processor, but deletion obligations still apply.

Consent is not bundled with HealthKit permission, Sportapp processing, coach sharing, notifications or marketing. Full account history is never sent by default merely because raw-data consent exists.

## Accepted change and revocation policy

- A change of recipient/provider instance, processing region, retention, training use or material subprocessor policy requires new notice and explicit consent before raw-health dispatch. A model-only change on the same owner-operated Ollama recipient under unchanged data policy uses a versioned notice.
- Revocation/account deletion immediately deletes unaccepted AI proposals and caches and prevents new dispatch. An already accepted plan remains part of plan history but is not sent for further AI processing without current consent. A processor deletion request is issued where contractually/technically available.
