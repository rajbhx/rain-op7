# OP7 engineering record — Rain

Playbook: `rajbhx/op7-special-build-playbook`. Skill: `op7-special-build`.
Target: OnePlus 7 (GM1901, Snapdragon 855, Adreno 640, arm64-v8a, Android 10/API 29, 8 GB).

## Change log (one optimization per revision)

| Change | Reason | Baseline | Result | Status |
|---|---|---|---|---|
| r1: none (unmodified upstream) | Level 0/1 compatibility baseline | rainManager 4c01d85…, rain f259364… | APK + bundle build in CI, badging passes | KEEP |
| r2 (planned) | see `docs/optimization.md` | on-device baseline required | — | pending |

## Compatibility matrix (OP7 / Android 10)

| Area | Upstream value | OP7 assessment |
|---|---|---|
| rainManager minSdk | 28 (Android 9) | ✅ Android 10 (29) ≥ 28 |
| rainManager targetSdk | 36 | ✅ runs on Android 10 |
| Storage | `requestLegacyExternalStorage=true`, SAF/FileProvider | ✅ Android 10 legacy access for downloaded APKs |
| Install path | Shizuku / `pm install` (PMInstaller) | ✅ Shizuku is proven on this device (playbook) |
| Permissions | INTERNET, REQUEST_INSTALL/DELETE_PACKAGES, MANAGE_EXTERNAL_STORAGE, QUERY_ALL_PACKAGES | ✅ later-API perms are no-ops on API 29; runtime flows present |
| ABI (manager) | no jniLibs; lspatch .so in assets (4 ABIs) | ✅ ABI-agnostic; patched Discord output inherits Discord ABIs → arm64-v8a on OP7 |
| Native injection | LSPatch + aliuhook (liblsplant, libc++_shared) | ✅ manager selects `Build.SUPPORTED_ABIS.first()` at patch time |
| Network | downloads Discord APK from `raincord.dev`, rainXposed from Codeberg releases | ✅ free infra, no paid services |
| JS runtime | rain bundle runs inside patched Discord's Hermes | ✅ rain is built to the same Hermes bytecode (0.16.0) upstream ships |
| Build | JDK 21, Gradle 8.14.3, AGP 8.11.0, Kotlin 2.2.0, Compose | ✅ upstream's own GitHub Actions combo, reused |

## Known upstream quirks (documented, not changed)

- rainManager is derived from the Aliucord Manager codebase (`com.aliucord.manager` package) — upstream design, kept.
- rainManager downloads the Discord APK from its own backend; the OP7 build does
  not alter that trust chain. Supply-chain review: dependencies come from
  google()/mavenCentral()/maven.aliucord.com snapshots; lspatch.aar is committed
  upstream (`app/libs/`) — pinned by the upstream commit, flagged for review.
- rain's canonical CI lives on Codeberg Forgejo; this repo reuses the same build
  command on GitHub Actions (no behavior change).

## Optimization levels

- **L0 compatibility** — done (r1): build + install + launch expected.
- **L1 stability** — r1 APK passes structural gates; on-device smoke test is yours
  (launch, render UI, patch flow against a real Discord APK).
- **L2 performance** — only after your on-device baseline (`docs/benchmarking.md`);
  candidates listed in `docs/optimization.md`.
