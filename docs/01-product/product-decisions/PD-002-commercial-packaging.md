# PD-002 — Initial Commercial Packaging

- Status: Accepted with launch follow-ups
- Decision date: 2026-09-25
- Decision owner: Product owner

## Storefront and products

- Initial beta application distribution and IAP product availability: Turkey only.
- Monthly Pro: TRY 249.99.
- Annual Pro: TRY 1,999.99.
- Annual Pro introductory offer: eligible new subscribers receive a 7-day free trial with Pro access; unless cancelled, it renews at the annual price. Monthly Pro has no trial. Eligibility and required price/duration/renewal presentation remain provider-authoritative.
- Initial iOS purchase channel: StoreKit only.

Prices are customer-facing targets. App Store price points, proceeds, taxes, invoices, seller entity and localized product identifiers require launch approval. Entitlement is derived from verified StoreKit evidence, never from a client-supplied paid flag.

The implementation target is StoreKit 2. Free is the default database product policy and requires no StoreKit transaction. Pro requires server-verified transaction evidence bound through a random stable Sportapp-account `appAccountToken`, App Store Server Notifications V2 and API reconciliation. Bundle, product, environment, signed transaction and account ownership are verified; duplicate and out-of-order events are idempotent. A notification receives success only after durable inbox recording, and no unverified or deferred evidence grants Pro.

## Free

- Account, privacy, consent, export and deletion controls.
- Catalog browsing and supported read-only HealthKit import.
- Rolling 30-day activity/history view.
- Up to 2 active sports.
- 1 AI-generated weekly-plan proposal per calendar month.
- Up to 4 AI adaptations per calendar month.
- Manual plan editing and email support.

## Pro

- Rolling 12-month imported health/activity history.
- All released, expert-reviewed supported sport combinations.
- Up to 5 AI-generated weekly-plan proposals per calendar month.
- Up to 30 AI adaptations per calendar month.
- Advanced history and comparison views.
- Coach sharing, review and approval where the coach capability is released.
- Plan revision history.

## Accepted lifecycle defaults

- Billing Grace Period is enabled. Pro remains active only while StoreKit reports a valid entitlement or grace state; exact supported duration is configured in App Store Connect before launch.
- A monthly-to-annual upgrade takes effect immediately according to StoreKit; an annual-to-monthly downgrade takes effect at the next renewal.
- Trial cancellation preserves provider-authoritative access until the trial entitlement expires. Payment failure outside verified grace and final expiry return the account to Free without deleting data.
- Support/admin cannot grant promotional Pro entitlements in the initial release.
- A verified StoreKit entitlement already bound to another Sportapp account is never transferred automatically; support performs an audited ownership review.
- Free retains 30 days of raw imported detail and rolling 12-month derived summaries. Pro retains rolling 12 months of raw imported detail.
- Family Sharing is disabled for the initial release.
- AI monthly quotas reset using `Europe/Istanbul` calendar boundaries.
- AI quota is reserved atomically when work starts and committed only when a valid result is delivered; failed or cancelled work releases the reservation and does not consume quota.
- Pro expiry/downgrade never deletes plans, sports, history or coach relationships. Resources above Free limits and Pro-only views become read-only/restricted; new activity requires the user to reduce usage to the Free cap or renew Pro.

## Required acceptance evidence

Purchase, `appAccountToken` ownership, restore, signed App Store notification/API reconciliation, duplicate/out-of-order events, refund/revocation, trial eligibility/disclosure, upgrades/downgrades and expiry require tests against the selected policies. Expiry never removes account, privacy, export, deletion or support access.
