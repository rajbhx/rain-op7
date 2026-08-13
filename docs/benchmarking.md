# Benchmarking — Rain OP7 (manual, on the real device)

All measurement happens on the OnePlus 7 by the user.

## rainManager (the APK)

- Cold start: force-stop → relaunch → time to interactive UI (label COLD).
- Patch flow: run a full Discord patch+install cycle with the SAME Discord
  version (ControlRepo) across revisions; record wall time per step and total.
- Memory: `dumpsys meminfo dev.raincord.manager` before/during/after patch.
- CPU/thermal: `dumpsys cpuinfo`, `dumpsys thermalservice` during patch.

## Patched Discord (rain client)

- Launch patched app; record cold start to loaded UI.
- UI responsiveness: scroll a channel list; note jank (SurfaceFlinger method in
  playbook docs/07), memory retention after heavy use.
- JS bundle impact: compare `rain.js` vs `rain.hbc` build sizes and launch time.

## What we need from you (to drive r2+)

- r1 numbers (above) for the `op7-signed-*` rainManager APK + `rain-bundle`,
- patched-app smoke result (render UI, navigate, network client works).

Then we implement exactly ONE candidate from `docs/optimization.md`, ship a new
revision, and you re-measure.
