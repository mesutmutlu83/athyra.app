# ADR-004: Admin-Configured Ollama with Extensible AI Adapters

- Status: Accepted with endpoint/model configuration follow-up
- Date: 2026-09-25
- Decision owners: Product owner
- Related feature(s): FEAT-001

## Context

The source brief proposed platform AI plus end-user BYOK/custom endpoints in P0. The product owner selected an owner-operated Ollama endpoint as the initial AI provider, configured through the private web admin, while preserving later reviewed provider adapters.

## Decision

Expose one Sportapp-managed AI experience backed initially by an Ollama adapter. Keep a server-side provider interface for capability discovery, structured generation, error normalization, usage limits and policy metadata. Authorized platform owners configure the Ollama base URL, model, optional authentication reference, task mapping, timeouts, output limits and kill state and run a constrained connection/capability test through the private admin panel. No end-user API-key entry or endpoint configuration is exposed in initial P0.

Non-secret settings are versioned in PostgreSQL. Provider credentials are write-only from the admin UI, envelope-encrypted under ADR-009, never returned after save, and referenced by opaque identifiers. Every change requires MFA/step-up authorization and an audit event. The Ollama adapter may use its native API or the documented supported subset of its OpenAI-compatible API, but capability discovery and schema validation remain explicit. A new provider type still requires a deployed, reviewed adapter.

The configured Ollama endpoint must be a Worker-reachable HTTPS origin. A desktop/server `localhost`, loopback, link-local address, arbitrary LAN discovery or cleartext remote HTTP endpoint is invalid from the Cloudflare deployment. Endpoint save/test performs scheme, hostname, resolved-address, redirect, port, timeout and response-size controls; redirects and unsafe/private targets fail closed. An owner-operated endpoint may be exposed through a reviewed authenticated gateway or tunnel.

All generated plans pass the same deterministic schema, catalog, feasibility and safety validation before becoming proposals. There is no silent provider fallback.

## Consequences

- The concrete Ollama host, model and capacity may be supplied later, but must pass region, retention, health-data, security, availability, structured-output and performance gates before AI integration testing.
- A later non-Ollama adapter is enabled in admin only after contract, privacy, capability, evaluation and threat-model gates pass.
- Local-device discovery and arbitrary LAN URLs remain out of scope.

## Security / data / operations impact

Prompts are purpose-minimized and consent-gated. Under PD-003, task-required raw health records may be included only for the approved provider, categories, purpose and bounded time window under separate explicit consent; consent never authorizes a default full-history transfer. Provider credentials use ADR-009. Adapter endpoints are policy-validated; arbitrary redirects, unsafe private-network access and user-supplied URLs are rejected.

## Rollback or migration considerations

Persist provider/model/policy metadata with generated artifacts. Disabling or replacing a provider must preserve prior plan provenance and must not silently regenerate accepted plans.
