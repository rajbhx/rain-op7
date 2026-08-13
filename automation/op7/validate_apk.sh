#!/usr/bin/env bash
# Structural validation gate for the RainManager OP7 APK (Phase 3/9).
# Checks: APK exists + parseable, package name, min/target SDK, NOT testOnly.
# NOTE: rainManager has NO jniLibs (lspatch .so live in assets/lspatch/so/ and are
# injected into the patched Discord APK at patch time), so no native-code gate.
set -euo pipefail

APK="${1:?usage: validate_apk.sh <path-to.apk>}"
OUT_DIR="${2:-$(dirname "$APK")}"
EXPECT_PACKAGE="${EXPECT_PACKAGE:-dev.raincord.manager}"
MAX_MIN_SDK="${MAX_MIN_SDK:-29}"   # Android 10

command -v aapt >/dev/null 2>&1 || AAPT="$(find "${ANDROID_HOME:-/usr/local/lib/android/sdk}/build-tools" -name aapt | sort -V | tail -n 1)"
command -v aapt >/dev/null 2>&1 && AAPT="$(command -v aapt)"
[[ -n "${AAPT:-}" && -x "$AAPT" ]] || { echo "::error::aapt not found"; exit 1; }

[[ -f "$APK" ]] || { echo "::error::APK not found: $APK"; exit 1; }
BADGING="$("$AAPT" dump badging "$APK")"
echo "$BADGING" | sed -n '1,6p'

grep -q "package: name='${EXPECT_PACKAGE}'" <<<"$BADGING" || { echo "::error::package name mismatch"; exit 1; }
MIN_SDK="$(grep -oP "sdkVersion:'\K[0-9]+" <<<"$BADGING" | head -1)"
TARGET_SDK="$(grep -oP "targetSdkVersion:'\K[0-9]+" <<<"$BADGING" | head -1)"
echo "minSdk=$MIN_SDK targetSdk=$TARGET_SDK"
[[ "$MIN_SDK" -le "$MAX_MIN_SDK" ]] || { echo "::error::minSdk $MIN_SDK > $MAX_MIN_SDK (Android 10)"; exit 1; }

if grep -q "testOnly='true'" <<<"$BADGING"; then
  echo "::error::APK is testOnly=true — will NOT install on Android 10 without -t"; exit 1
fi
echo "testOnly: absent (OK)"
echo "note: lspatch .so libs live in assets/ (injected into patched Discord APK at runtime)"

APK_BASENAME="$(basename "$APK")"
cp "$APK" "$OUT_DIR/$APK_BASENAME"
(
  cd "$OUT_DIR"
  sha256sum "$APK_BASENAME" > SHA256SUMS.txt
  cat > apk-metadata.json << JSON
{
  "apk": "$APK_BASENAME",
  "sha256": "$(awk '{print $1}' SHA256SUMS.txt)",
  "package": "$EXPECT_PACKAGE",
  "minSdk": $MIN_SDK,
  "targetSdk": $TARGET_SDK,
  "note": "manager APK is ABI-agnostic; patched Discord output inherits Discord ABIs (arm64-v8a on OP7)",
  "size_bytes": $(stat -c %s "$APK")
}
JSON
)
echo "VALIDATION PASSED"
