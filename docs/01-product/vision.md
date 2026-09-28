# Product Vision

## Product

Sportapp is a multi-sport digital coaching and decision-support product. It combines permissioned records already available from health/fitness applications with user goals, availability, constraints, and feedback to create weekly plans, evaluate completed activity, and propose adaptations.

## Core promise

- Answer “What should I do this week?” and “What should I do now given what actually happened?”
- Preserve provenance and uncertainty: imported records, user/coach statements, and Sportapp analysis are distinct.
- Support adult single-sport and multi-sport users; racing is optional.
- Keep the athlete’s history portable across coach and AI-provider changes.

## Initial product surfaces

- Native iPhone application for athletes and coaches, targeting the iPhone 12 family and later models.
- Private browser-based admin panel for product operations, membership/billing tracking, and minimum CRM.
- Shared backend, workers, database, policy enforcement, and AI gateway.

## Binding boundaries

Sportapp does not measure physiology, pair with devices, record live workouts, stream sensor data, track GPS routes, control equipment, provide a watch app, or write/delete records in external health stores. It reads existing permissioned records through supported official mechanisms.

The full supplied source is preserved in [project-brief.md](project-brief.md). This file is the compact canonical vision; implementation status must not be inferred from the source brief.
