# Troubleshooting — Rain OP7

Search the playbook notes first: `python3 scripts/lookup.py <problem words>`.

## Known failure modes

| Symptom | Likely cause | Fix |
|---|---|---|
| "App not installed" on Android 10 | `testOnly=true`, or signature mismatch across builds | validation gate rejects testOnly; use `op7-signed-*` artifact (stable debug key) |
| Patched Discord fails to install | Discord version drift vs aliuhook/rainXposed | ControlRepo pin (manager fetches); keep rainXposed updated |
| Gradle can't resolve `maven.aliucord.com` snapshots | network/maven outage | retry; pin handled by upstream versions catalog |
| rain bundle build fails | hermes-compiler platform binary missing | `bun install` with `trustedDependencies` (upstream package.json) |
| Shizuku install fails on OP7 | pm permission / Shizuku not running | playbook device-access notes (Shizuku transport) |
| Patch conflict after upstream update | upstream changed patched files | stop, report, rebase patch; never force |

## On-device install

```bash
adb install -r <op7-signed-*.apk>
# or: open rainManager, grant Shizuku, run the patch flow
adb shell dumpsys package dev.raincord.manager | head
```

If something is genuinely new and solved here, record it in
`docs/field-notes/log.yml` (playbook loop).
