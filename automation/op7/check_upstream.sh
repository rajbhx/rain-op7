#!/usr/bin/env bash
# Lightweight upstream change detection for both rain components. NEVER builds.
# Exit codes: 0 = unchanged, 1 = changed, 2 = unreachable.
# Prints new_head lines for any changed component (rain=..., rainManager=...).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHANGED=0

check_one() {
  local repo="$1" pinfile="$2" label="$3"
  local new
  new="$(curl -fsSL "https://api.github.com/repos/${repo}/commits/main" | jq -r '.sha' 2>/dev/null || true)"
  if [[ -z "$new" || "$new" == "null" ]]; then
    echo "error: could not resolve upstream HEAD for ${repo}@main" >&2
    return 2
  fi
  local pinned
  pinned="$(tr -d '[:space:]' < "$pinfile")"
  echo "${label}: pinned=$pinned upstream=$new"
  if [[ "$new" != "$pinned" ]]; then
    echo "new_head_${label}=$new"
    return 1
  fi
  return 0
}

rc=0
check_one ra1ncord/rain "$REPO_ROOT/upstream/rain/commit.txt" rain || rc=$?
check_one ra1ncord/rainManager "$REPO_ROOT/upstream/rainManager/commit.txt" rainManager || rc=$?

if [[ "$rc" -eq 2 ]]; then exit 2; fi
[[ "$rc" -eq 0 ]] && { echo "result: unchanged"; exit 0; }
echo "result: changed"
exit 1
