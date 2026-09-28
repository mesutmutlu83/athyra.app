# Observability

Required future telemetry includes correlation/job IDs, sync/import latency and wait reason, retry/stuck jobs, plan/schema validation, stale proposals, authorization denials, AI task latency/schema/policy result and bounded usage, catalog import/review status, configuration validation/publish/rollback outcome, active release/version, stale-client fallback and cache invalidation health, billing unmatched/reconciliation lag, CRM/support workflow counts, and client crash/hang/performance by supported device/OS branch.

Raw health content, email/provider subjects, credentials, private notes, prompts containing sensitive data, and unnecessary financial payloads must not be logged.

Configuration telemetry records stable keys, revision/release identifiers, actor references and outcomes—not secret values or sensitive before/after payloads. Alerting must detect repeated publish failures, invalid public snapshots, unexpected rollback and clients remaining on last-known-good beyond the defined threshold.

Lean beta has no public uptime SLA or 24/7 on-call promise. Operational alerts route to the named owner during the approved support window. A working support page and configured support email are release requirements; provider/address/owner remain open in `PD-001`.
