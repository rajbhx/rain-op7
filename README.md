# Rain · OnePlus 7 Edition

[![OP7 Build](https://github.com/rajbhx/rain-op7/actions/workflows/op7-build.yml/badge.svg)](https://github.com/rajbhx/rain-op7/actions/workflows/op7-build.yml)
[![CI](https://github.com/rajbhx/rain-op7/actions/workflows/ci.yml/badge.svg)](https://github.com/rajbhx/rain-op7/actions/workflows/ci.yml)
[![Upstream Check](https://github.com/rajbhx/rain-op7/actions/workflows/upstream-check.yml/badge.svg)](https://github.com/rajbhx/rain-op7/actions/workflows/upstream-check.yml)

**Rain OP7** builds the [ra1ncord](https://github.com/ra1ncord) Discord client
mod for the **OnePlus 7** (Snapdragon 855, Android 10, arm64-v8a) on free GitHub
Actions. It is a build repo, not an app fork: upstream components are pinned and
built unmodified; the OP7 layer is thin, documented, and auto-synced.

## What actually gets built (repository discovery, per mission B1)

| Component | Role in the OP7 build |
|---|---|
| [rain](https://github.com/ra1ncord/rain) (TypeScript) | Discord client core → `rain.js` + `rain.hbc` bundle (built in CI) |
| [rainManager](https://github.com/ra1ncord/rainManager) (Kotlin) | **the APK users install** — downloads Discord, patches it, injects rain |
| [rainXposed](https://github.com/ra1ncord/rainXposed) | Xposed module fetched at patch time by the manager (reference pin) |
| [RainTweak](https://github.com/ra1ncord/RainTweak) (C++) | iOS-only tweak — **excluded** from the Android build |

## Status

| Revision | Content | Status |
|---|---|---|
| **r1** | Unmodified upstream baseline: rainManager APK + rain bundle via GitHub Actions, badging gates | ✅ this revision |
| r2+ | One measured optimization per revision (see `docs/optimization.md`) | 🔄 planned |

## Quick start

- **Get the APK**: `Actions → OP7 Build → workflow_dispatch` → download the
  `op7-signed-*` artifact (rainManager) and `rain-bundle` (client bundle).
- **Dispatch**: `gh workflow run op7-build.yml -f fast=true -f release=false`
- Install rainManager on the OP7, then let it patch + install Discord (needs
  Shizuku/root, exactly like upstream).

See `docs/build.md` (pipeline) and `docs/benchmarking.md` (on-device measuring).
