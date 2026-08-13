# Architecture — Rain OP7

## Ecosystem map (audited 2026-08-13)

```
rain (TypeScript, RN-adjacent client core)
  └─ build.mjs: esbuild+SWC bundle -> dist/rain.js (iife), hermes-compiler -> rain.hbc
rainManager (Kotlin/Compose patcher app)   <- the deliverable APK
  ├─ downloads official Discord APK (raincord.dev backend, version via ControlRepo)
  ├─ downloads rainXposed release + aliuhook deps (Codeberg)
  ├─ patches APK: smali patch, manifest, icons, dex reorg, aliuhook libs
  │   (libaliuhook.so, libc++_shared.so, liblsplant.so for Build.SUPPORTED_ABIS.first())
  ├─ injects rain bundle into the patched APK
  ├─ re-signs (apksig) and installs via Shizuku/pm (PMInstaller)
  └─ lspatch.aar + assets/lspatch/so/* (injection runtime, committed upstream)
RainTweak (C++/Theos)  -> iOS-only, excluded
```

## OP7 layer (this repo)

```
pinned upstream (rain + rainManager commits)
  -> patches/op7 + patches/rain        (r1: none required)
  -> GitHub Actions                    mirror -> apply -> build -> aapt badging -> artifacts
  -> validated rainManager APK + rain bundle
```

## OP7 invariants

- Never fork/modify the client core; rain stays upstream-built.
- Keep the manager's patch pipeline (smali/LSPatch/aliuhook) untouched.
- Android 10: rely on `requestLegacyExternalStorage`, SAF, and Shizuku pm install
  (proven on this device via the playbook).
- One measured optimization per revision; every change lands as a documented patch.
