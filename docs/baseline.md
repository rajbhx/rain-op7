# Baseline — Rain OP7 (r1)

Recorded 2026-08-13 from upstream audit (no local build — CI reproduces this).

## Upstream pins

| Component | Repo | Commit |
|---|---|---|
| rain (TS core) | ra1ncord/rain | `f25936479cdf57b777d54d1e4e22624262996b4d` |
| rainManager (Android app) | ra1ncord/rainManager | `4c01d85a7b0b6b668be27c16439af15b4959138c` |
| rainXposed (runtime-fetched) | ra1ncord/rainXposed | `83752a64f113ba1663ca7f6a58c85cfe2565ab0a` (reference) |
| RainTweak (iOS) | ra1ncord/RainTweak | excluded |

## Build environment

- rainManager: JDK 21 (zulu), Gradle 8.14.3 (wrapper), AGP 8.11.0, Kotlin 2.2.0,
  Compose 1.8.3, compileSdk 36, minSdk 28, targetSdk 36, package
  `dev.raincord.manager`, versionName v1.0.1 / versionCode 1010.
- rain: bun 1.x, esbuild + SWC + hermes-compiler 0.16.0 →
  `dist/rain.js` (+ `rain.hbc` bytecode), iife bundle.
- Build commands (as upstream CI):
  - manager: `./gradlew :app:assembleDebug` (fast) / `:app:assembleDebug :app:assembleStaging` (full)
  - bundle: `bun run build --release-branch=main --build-bytecode`

## Expected baseline artifacts (populated by first CI run)

- `app-debug.apk` (rainManager) + SHA-256 + metadata
- `rain.js` / `rain.hbc` bundle

## On-device baseline (to be filled by manual testing)

Cold start of rainManager, patch-flow success against a real Discord APK on
Android 10, patched-app launch, UI render, memory — see `docs/benchmarking.md`.
No performance claim is made until real numbers exist (playbook rule).
