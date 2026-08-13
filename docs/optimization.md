# Optimization — Rain OP7

Playbook rule: **one measured optimization per revision**; baseline first;
revert on regression. r1 is the compatibility baseline — no optimization claimed.

## Candidate list (NOT applied — each needs an on-device baseline first)

| ID | Change | Hypothesis | Metric | Risk |
|---|---|---|---|---|
| OP7-OPT-001 | Restrict lspatch assets to `arm64-v8a` only | smaller APK, faster patch write | APK size, patch time | none on OP7 (ABI fixed) |
| OP7-OPT-002 | Pin Discord APK version via ControlRepo locally (cache) | faster re-patch, less network | patch time | stale version drift |
| OP7-OPT-003 | rain bundle: build with `--build-minify` | smaller injected JS | bundle size, launch | JS behavior changes — verify features |
| OP7-OPT-004 | Manager cold-start: Compose/R8 tune | faster UI | cold start | — |

## Decision template (use for every revision)

```
Revision: OP7-OPT-00X
Change:
Hypothesis:
Baseline:
After:
Result: PASS / FAIL
Regression:
Decision: KEEP / REVERT
```

## Rules

- No change without an on-device before/after (`docs/benchmarking.md`); label
  data "contended" when the device was in use.
- Never remove client functionality (plugins, features) to win a benchmark.
- RainTweak (iOS) stays excluded; rainXposed stays runtime-fetched (upstream design).
