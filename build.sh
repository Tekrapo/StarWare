#!/usr/bin/env bash
# Build s2ext on a PC. Requires JDK 17 and Android SDK 34.
#
#   ./build.sh
#
# Result: s2ext-debug.apk next to this script.
set -euo pipefail
cd "$(dirname "$0")"

say() { printf '%s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

command -v java >/dev/null 2>&1 || die "java not found (install JDK 17)"
say "java: $(java -version 2>&1 | head -1)"

if [ ! -f local.properties ]; then
    if [ -n "${ANDROID_HOME:-}" ]; then
        printf 'sdk.dir=%s\n' "$ANDROID_HOME" > local.properties
    elif [ -n "${ANDROID_SDK_ROOT:-}" ]; then
        printf 'sdk.dir=%s\n' "$ANDROID_SDK_ROOT" > local.properties
    else
        die "set ANDROID_HOME or create local.properties with sdk.dir=/path/to/Android/Sdk"
    fi
fi

if [ ! -x ./gradlew ]; then
    command -v gradle >/dev/null 2>&1 || die "gradlew missing and gradle not found (install Gradle 8.7+)"
    gradle wrapper --gradle-version 8.7
fi

./gradlew --no-daemon :app:assembleDebug

APK="app/build/outputs/apk/debug/app-debug.apk"
[ -f "$APK" ] || die "gradle finished but $APK is missing"
cp "$APK" ./s2ext-debug.apk

say ""
say "APK: $(pwd)/s2ext-debug.apk"
if command -v sha256sum >/dev/null 2>&1; then
    sha256sum ./s2ext-debug.apk
else
    shasum -a 256 ./s2ext-debug.apk
fi
