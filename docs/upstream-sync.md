# Upstream sync — Rain OP7

Loop: **detect → sync → patch → build → validate → release or report** (playbook doc 06).
Two independent upstreams: `ra1ncord/rain` (bundle) and `ra1ncord/rainManager` (APK).

## Detection (daily, never builds)

`upstream-check.yml` compares both pins (`upstream/rain/commit.txt`,
`upstream/rainManager/commit.txt`) against each repo's `main`. On change it
opens a "sync available" issue and dispatches `op7-build.yml` with the new commit(s).

## Sync procedure (maintainer)

1. Update the changed pin file(s) to the new SHA.
2. Rebase `patches/rain/*.patch` / `patches/op7/*.patch` onto the new trees; run CI.
3. Dispatch a fast validation build; on green, decide on release.

## Conflict policy (hard)

- A patch that fails `git apply --3way` **stops** the pipeline: no build, no
  release. Report upstream commit, failing patch, affected files, likely cause,
  required human decision.
- Never force-reset, never silently rewrite hunks, never auto-publish a broken merge.

## Safety invariant

Release valid only if: sync ok → patches ok → deps resolve → compile ok → APK
exists → badging ok → signing ok → checksum ok. Any gate fails → no release.
rainXposed is runtime-fetched by the manager (Codeberg releases) — its pin here
is a reference only, not a build input.
