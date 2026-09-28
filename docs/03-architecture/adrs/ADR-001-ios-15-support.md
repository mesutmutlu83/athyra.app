# ADR-001: iOS 15 Minimum Deployment Target

- Status: Accepted
- Date: 2026-09-25
- Decision owners: Product owner
- Related feature(s): FEAT-001

## Context

The product targets the iPhone 12 family and later devices. Historical iPhone 12 support began on iOS 14, but the current supported Xcode toolchain documents iOS 15 as its minimum deployment target.

## Constraints

- Native iPhone athlete and coach experiences remain P0.
- iPhone 12 mini is the small-screen and lower-bound performance device.
- Store submission must use a currently accepted Xcode/SDK combination.
- A deployment-target value alone is not compatibility evidence.

## Options considered

- iOS 15+: accepted; broadest currently supported engineering baseline.
- iOS 16+: rejected for now; unnecessarily narrows the requested audience.
- iOS 14+: rejected; no current supported build and distribution route was established.

## Decision

Use iOS 15 as the minimum deployment target. Preserve iPhone 12-family and later device intent without artificial device-capability exclusions.

## Consequences

- Dependencies, navigation, persistence and authentication SDKs must support iOS 15.
- Newer APIs require availability checks and functional fallbacks.
- Release evidence must include the minimum supported OS on physical iPhone 12-family hardware where obtainable, plus the current stable OS branch.
- Product and marketing material must not claim iOS 14 support.

## Security / data / operations impact

Unsupported toolchain workarounds and abandoned dependencies are prohibited. The support matrix is revalidated for each release.

## Rollback or migration considerations

Raising the minimum OS later is a new product decision with usage, security, dependency and App Store evidence. Lowering it requires a proven supported toolchain and full regression evidence.
