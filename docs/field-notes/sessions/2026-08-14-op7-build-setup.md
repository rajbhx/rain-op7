# Session digest — 2026-08-14 — OP7 build setup (Rain)

Brought the ra1ncord Discord client mod to a GitHub-Actions-only OP7 pipeline:
rainManager (Kotlin patcher APK) pinned 4c01d85a + rain bundle (TS) pinned
f2593647; both built on CI, validated with aapt badging gates.

## Problems solved
- **P** which ra1ncord repos are actually needed for the Android build was ambiguous
  cause: org has rain (TS), rainManager (Kotlin), rainXposed (Kotlin), RainTweak (C++)
  solution: mapped ecosystem - deliverable APK = rainManager; bundle = rain; rainXposed runtime-fetched; RainTweak iOS-only excluded
  section: A
  tags: [architecture, repository-discovery, discord]
- **P** rainManager ships no native-code entries in badging (lspatch .so live in assets)
  cause: lspatch runtime is injected into the patched Discord APK, not used by the manager itself
  solution: validation gate for the manager checks package/SDK/testOnly only; patched-output ABI is inherited from Discord (arm64-v8a on OP7)
  section: B
  tags: [abi, lspatch, badging]
- **P** upstream rain CI runs on Codeberg Forgejo, not GitHub
  cause: canonical repo is codeberg raincord; GitHub ra1ncord is a mirror
  solution: reuse the exact build command (bun run build --release-branch=main --build-bytecode) on GitHub Actions; pin GitHub mirror commits
  section: C
  tags: [ci, forgejo, github-actions, mirror]

## Notes (optional)
- rainManager is ABI-agnostic; the patched Discord APK inherits Discord ABIs (arm64-v8a on OP7).
- lspatch assets keep all ABIs so any Discord APK can be patched; OP7 uses arm64-v8a.
