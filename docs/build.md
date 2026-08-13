# Build — Rain OP7 (all builds run on GitHub Actions)

## Workflows

| Workflow | Trigger | Cost |
|---|---|---|
| `op7-build.yml` | `workflow_dispatch` | heavy (only build) — jobs: `rain-bundle`, `manager` |
| `upstream-check.yml` | daily cron + dispatch | ~free (never builds) |
| `ci.yml` | push/PR | cheap (actionlint + shellcheck + pins) |
| `maintenance.yml` | monthly cron + dispatch | ~free (prunes artifacts/caches/runs) |

## Pipeline (op7-build.yml)

1. `rain-bundle` job: mirror `ra1ncord/rain` at pin → apply `patches/rain` →
   `bun install --frozen-lockfile` → `bun run build --release-branch=main
   --build-bytecode` → upload `rain.js` + `rain.hbc`.
2. `manager` job: mirror `ra1ncord/rainManager` at pin → apply `patches/op7` →
   JDK 21 + `gradle/actions/setup-gradle` → `assembleDebug` (fast) or
   `assembleDebug + assembleStaging` (full) → aapt badging gate
   (`automation/op7/validate_apk.sh`: package, SDK ≤ 29, NOT testOnly) →
   re-sign with stable debug key (secret) → upload APK + metadata.
3. `release=true` → dedicated release job under the `release` environment
   (secrets guarded), publishes GitHub Release.

## Dispatch examples

```bash
gh workflow run op7-build.yml -f fast=true -f release=false
gh workflow run op7-build.yml -f upstream_commit=<manager-sha> -f rain_commit=<rain-sha> -f fast=true
gh workflow run op7-build.yml -f fast=false -f release=true -f release_tag=op7-rain-v1.0.1-r1
```

## Free-tier hygiene

- `fast=true` (assembleDebug only) for iteration; full R8 builds opt-in.
- Artifacts: 7/14-day retention; monthly maintenance prunes >14 d artifacts,
  caches, old runs (500 MB / 10 GB limits).
- Upstream check never builds; every dispatch resets the scheduled-window clock.
