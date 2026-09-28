# FEAT-002 UX

## Information architecture

- **Configuration:** Product Configuration, Feature Flags, Environment/Version Overrides, Published History.
- **Metadata:** Sports, Families, Variants, Training Methods, Session Purposes, Body Regions, Muscle Groups, Movement Patterns, Equipment, Levels, Units where product-managed.
- **Content:** Exercises, Drills, Poses, Stations, Aliases, Source Mappings, Review Queue.
- **Integrations:** Registry, Provider Detail, Capability Matrix, Runtime State, Data Mappings, Verification History.
- **Release Management:** Draft Change Sets, Validation Results, Diff, Publish, Rollback, Audit.

Existing Users, Billing and CRM navigation remains intact.

## Primary flow

Authorized editor opens a scoped list → filters/searches → creates or changes a draft → sees affected relations/compatibility → validates → resolves errors → publisher reviews a human-readable diff → enters reason and completes step-up → publishes atomically → observes release/caches/client compatibility → can roll back to a prior valid release.

## Required states

- Loading, empty, partial/paginated, stale, error and retry.
- Read-only, permission denied, step-up required and publish conflict.
- Draft, validating, validation failed, ready, active, superseded, rolled back, deprecated/withdrawn.
- Integration unconfigured, configured, test running, verified, partially verified, maintenance, provider-blocked and unsupported-on-platform.
- Offline/unreachable public config uses last-known-good with freshness/version messaging where material.

## Interaction rules

- Never use one toggle for all integration behavior; show visibility, new connections, backend execution, maintenance and existing-connection policy separately with consequence text.
- Destructive-looking actions default to deactivate/deprecate/replace. Hard delete appears only for unreferenced drafts.
- Publish and rollback always show environment, version, compatibility, affected counts, warnings and irreversible external effects.
- Secret inputs are replace-only, masked after save, and connection-test results never echo values.
- Relationship management supports table/search/graph-assisted views; a tree is not mandatory.
- Bulk edits require preview, bounded selection, validation summary and confirmation.

## Accessibility and responsive behavior

Desktop is the primary admin workspace, with usable tablet fallback. Keyboard order, focus restoration, error summary links, non-color-only status, accessible data-grid semantics and screen-reader labels meet WCAG 2.2 AA. Large diffs/capability matrices provide textual summaries and filters rather than relying on color.
