---
name: mobile-engineering
description: Implement or review native/cross-platform mobile applications with platform-aware lifecycle, state, navigation, storage, networking, permissions, security, accessibility, performance, offline/error handling, testing, and store/distribution concerns.
---

Use `regression-safety` for behavior-changing mobile work, including upgrade/lifecycle/permission/offline compatibility.
First detect the actual mobile stack and versions. Do not assume native, Flutter, React Native, Kotlin Multiplatform, SwiftUI, Compose, UIKit, or XML without repository evidence.

## Common mobile principles

- Treat mobile clients as untrusted clients; authorization remains server-side.
- Never embed server secrets, private API keys, signing secrets, or privileged credentials in the app.
- Keep environment/configuration values in the project's approved configuration mechanism.
- Handle loading, empty, success, error, offline, permission-denied, retry, interrupted, and re-entry states where relevant.
- Respect app lifecycle changes and state restoration.
- Keep expensive/blocking work off the UI thread.
- Use platform-native secure storage for sensitive local tokens/credentials when required.
- Minimize sensitive local data and define retention/cleanup behavior.
- Validate all server/external data before use.
- Use bounded timeouts/retries and avoid uncontrolled retry loops.
- Consider intermittent connectivity and partial failure.
- Avoid battery-heavy polling/background work.
- Make deep links/universal links/app links explicit contracts.
- Review notification behavior for privacy and permission impact.
- Use accessibility APIs, semantic labels, dynamic type/font scaling, focus order, contrast, and touch-target guidance appropriate to the platform.
- Support approved device classes/orientations/screen sizes.
- Measure startup, memory, rendering, networking, and storage performance when risk is material.
- Add unit, integration, UI, and platform-specific tests according to risk and project conventions.
- Do not introduce a new mobile architecture/framework/library as a side effect of unrelated work.

## Android-specific checks

When the project is Android:
- detect Kotlin/Java versions, Gradle/AGP versions, minSdk/targetSdk, Compose/View system, dependency injection, persistence, networking, and test stack;
- use lifecycle-aware components and structured concurrency;
- respect runtime permissions and Android background-execution rules;
- consider process death/configuration change;
- use secure Android storage APIs when sensitive local data is necessary;
- consider adaptive layouts and device classes;
- keep Play policy/privacy implications visible when relevant.

## iOS-specific checks

When the project is iOS:
- detect Swift/Objective-C, Swift language/toolchain, minimum deployment target, SwiftUI/UIKit, concurrency model, persistence, networking, and test stack;
- respect app/scene lifecycle and state restoration;
- use Swift concurrency/MainActor correctly;
- respect entitlements, capabilities, permission strings, and background-task constraints;
- use Keychain or other approved Apple security primitives where appropriate;
- consider Dynamic Type, VoiceOver, safe areas, size classes, and supported device families;
- keep App Store/privacy-manifest implications visible when relevant.

## Cross-platform repositories

If the project uses Flutter, React Native, Kotlin Multiplatform, or another cross-platform stack:
- follow the repository's existing architecture;
- do not force native duplication unnecessarily;
- still review Android/iOS platform integration separately for permissions, signing, entitlements, lifecycle, deep links, notifications, store configuration, and native modules;
- route platform-specific implementation to Android/iOS specialists when native code or platform behavior is materially affected.
