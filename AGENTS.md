# AGENTS.md — Rain OP7 build repo

Produces a OnePlus 7–optimized Rain (Discord client mod) Android build:
- `rainManager` APK (Kotlin patcher app that downloads Discord, patches it, and
  injects the rain client) — the deliverable users install,
- `rain` JS/bytecode bundle (TypeScript client core) built for the manager,
- rainXposed is fetched at runtime by the manager (reference pin only),
- RainTweak is iOS-only and EXCLUDED.

Upstream: `ra1ncord/rain` (TS) + `ra1ncord/rainManager` (Android).
OP7 changes live ONLY in `patches/op7/` (manager) and `patches/rain/` (bundle);
r1 = unmodified upstream baseline.

## Before doing anything
- Load the `op7-special-build` skill; search the playbook before inventing.

## Hard rules (from the field)
- Baseline before optimization; measure on the real device (user tests manually).
- One measured optimization per revision (`op7-revision.txt`, `op7r<N>`); revert on regression.
- Iteration: dispatch with `-f fast=true` (assembleDebug). Release only when ready.
- Never publish an unvalidated build; patch conflicts stop the pipeline.
- Never commit APKs/keystores; never run Android builds locally (all on GitHub Actions).
