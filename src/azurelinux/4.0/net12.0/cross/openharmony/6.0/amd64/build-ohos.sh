#!/usr/bin/env bash
# Build the OpenHarmony cross-compilation assets for the prereqs image:
# the SDK/NDK, static OpenSSL and ICU, and the target toolchain wrappers.
set -euo pipefail

: "${OHOS_NDK_HOME:=/opt/ohos-sdk/linux}"
: "${OHOS_ASSETS:=/opt/ohos-assets}"
: "${OHOS_TOOLCHAIN:=/opt/ohos-toolchain}"

OHOS_SDK_URL="${OHOS_SDK_URL:-https://repo.huaweicloud.com/openharmony/os/6.0-Release/ohos-sdk-windows_linux-public.tar.gz}"
OHOS_SDK_SHA="${OHOS_SDK_SHA:-a315834ac133625efc912bd078f3e2b2550868d04aef1b5aa4f9679c8b3c9d8e}"
OPENSSL_VERSION="${OPENSSL_VERSION:-3.3.1}"
OPENSSL_SHA256="${OPENSSL_SHA256:-777cd596284c883375a2a7a11bf5d2786fc5413255efab20c50d6ffe6d020b7e}"
ICU_VERSION="${ICU_VERSION:-75.1}"
ICU_SHA256="${ICU_SHA256:-cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef}"

ICU_TAG="${ICU_VERSION/./-}"
ICU_FILE="${ICU_VERSION/./_}"

OPENSSL_URL="${OPENSSL_URL:-https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz}"
ICU_URL="${ICU_URL:-https://github.com/unicode-org/icu/releases/download/release-$ICU_TAG/icu4c-$ICU_FILE-src.tgz}"

SDK_ROOT="$(dirname "$OHOS_NDK_HOME")"
TOOLCHAIN="$OHOS_TOOLCHAIN/bin"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

CURL_OPTS=(-fSL --proto '=https' --connect-timeout 30 --retry 5 --retry-delay 5 \
           --retry-all-errors --speed-limit 1024 --speed-time 60)

for tool in curl python3 make perl awk; do
    command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }
done

mkdir -p "$SDK_ROOT" "$OHOS_ASSETS" "$TOOLCHAIN"

echo "== SDK =="
curl "${CURL_OPTS[@]}" "$OHOS_SDK_URL" -o "$WORK/sdk.tar.gz"
echo "$OHOS_SDK_SHA  $WORK/sdk.tar.gz" | sha256sum -c -
tar -xzf "$WORK/sdk.tar.gz" -C "$SDK_ROOT" --no-same-owner
# The image is an aarch64 Linux cross toolchain only. Keep the native SDK
# component and discard the host/other-language SDK payloads.
rm -rf "$SDK_ROOT/windows" "$SDK_ROOT/ohos"
cd "$OHOS_NDK_HOME"
for archive in native-linux-x64-*.zip; do
    # python3 -m zipfile drops the symlinks stored in the SDK; recreate them.
    python3 - "$archive" <<'PY'
import os
import stat
import sys
import zipfile

with zipfile.ZipFile(sys.argv[1]) as zf:
    for info in zf.infolist():
        mode = info.external_attr >> 16
        if stat.S_ISLNK(mode):
            target = zf.read(info).decode()
            parent = os.path.dirname(info.filename)
            if parent:
                os.makedirs(parent, exist_ok=True)
            if os.path.lexists(info.filename):
                os.remove(info.filename)
            os.symlink(target, info.filename)
        else:
            zf.extract(info)
PY
done
find native/llvm/bin -type f -exec chmod +x {} +
find native/build-tools -type f -exec chmod +x {} + 2>/dev/null || true
# None of the remaining SDK payloads are needed by the aarch64 native build.
rm -f "$SDK_ROOT/linux"/*.zip
rm -rf native/docs
rm -rf native/llvm/python3
rm -rf native/llvm/bin/python
rm -rf native/llvm/bin/lldb*
rm -rf native/llvm/lib/liblldb*

# Keep the compiler, linker, archiver, binutils and symbolizer used by the
# cross build; drop the analysis, debug, LTO-IR and non-ELF driver payloads.
rm -f native/llvm/bin/clang-check \
      native/llvm/bin/clang-tidy \
      native/llvm/bin/clangd \
      native/llvm/bin/clang-format \
      native/llvm/bin/clang-apply-replacements \
      native/llvm/bin/clang-change-namespace \
      native/llvm/bin/clang-include-fixer \
      native/llvm/bin/clang-query \
      native/llvm/bin/clang-rename \
      native/llvm/bin/opt \
      native/llvm/bin/llc \
      native/llvm/bin/dsymutil \
      native/llvm/bin/llvm-dwp \
      native/llvm/bin/llvm-cfi-verify \
      native/llvm/bin/llvm-cov \
      native/llvm/bin/llvm-dwarfdump \
      native/llvm/bin/llvm-rc \
      native/llvm/bin/llvm-lib \
      native/llvm/bin/llvm-as \
      native/llvm/bin/llvm-dis \
      native/llvm/bin/llvm-link \
      native/llvm/bin/llvm-modextract \
      native/llvm/bin/llvm-profdata \
      native/llvm/bin/llvm-size \
      native/llvm/bin/llvm-strings \
      native/llvm/bin/llvm-readobj \
      native/llvm/bin/yaml2obj \
      native/llvm/bin/sancov \
      native/llvm/bin/sanstats \
      native/llvm/bin/scan-build \
      native/llvm/bin/scan-view \
      native/llvm/bin/FileCheck \
      native/llvm/bin/count \
      native/llvm/bin/not \
      native/llvm/bin/lld-link \
      native/llvm/bin/ld64.lld
# The image targets aarch64 only; other target runtimes and libclang's stable
# C API are not used by the compiler driver.
rm -rf native/llvm/lib/arm-linux-ohos native/llvm/lib/x86_64-linux-ohos
rm -f native/llvm/lib/libclang.so

# The final image provides CMake and the compiler from the base/build stages.
# The SDK's bundled CMake/LLVM module files are not used by the runtime or SDK
# builds; native/llvm/include is NOT removable because the SDK compiler needs
# its C++ standard-library headers even for host ICU builds.
rm -rf native/build-tools/cmake
rm -rf native/llvm/share
rm -rf native/llvm/lib/cmake
rm -rf native/llvm/libexec
test -f "$OHOS_NDK_HOME/native/build/cmake/ohos.toolchain.cmake"

NDK_BIN="$OHOS_NDK_HOME/native/llvm/bin"
export PATH="$NDK_BIN:$PATH"
SYSROOT="$OHOS_NDK_HOME/native/sysroot"
mkdir -p "$TOOLCHAIN"
mk() {
    printf '#!/bin/sh\nexec %s "$@"\n' "$2" > "$TOOLCHAIN/aarch64-linux-ohos-$1"
    chmod +x "$TOOLCHAIN/aarch64-linux-ohos-$1"
}
mk gcc "$NDK_BIN/clang --target=aarch64-linux-ohos --sysroot=$SYSROOT"
mk g++ "$NDK_BIN/clang++ --target=aarch64-linux-ohos --sysroot=$SYSROOT"
mk cc "$NDK_BIN/clang --target=aarch64-linux-ohos --sysroot=$SYSROOT"
mk c++ "$NDK_BIN/clang++ --target=aarch64-linux-ohos --sysroot=$SYSROOT"
mk ar "$NDK_BIN/llvm-ar"
mk ranlib "$NDK_BIN/llvm-ranlib"
mk nm "$NDK_BIN/llvm-nm"
mk strip "$NDK_BIN/llvm-strip"
mk objcopy "$NDK_BIN/llvm-objcopy"
mk objdump "$NDK_BIN/llvm-objdump"

echo "== OpenSSL $OPENSSL_VERSION =="
curl "${CURL_OPTS[@]}" "$OPENSSL_URL" -o "$WORK/openssl.tar.gz"
echo "$OPENSSL_SHA256  $WORK/openssl.tar.gz" | sha256sum -c -
tar -xzf "$WORK/openssl.tar.gz" -C "$WORK" --no-same-owner
cd "$WORK/openssl-$OPENSSL_VERSION"
./Configure linux-aarch64 \
    --cross-compile-prefix="$TOOLCHAIN/aarch64-linux-ohos-" \
    --prefix="$OHOS_ASSETS/openssl" --openssldir="$OHOS_ASSETS/openssl/ssl" --libdir=lib \
    no-shared no-tests no-async no-apps -fPIC
make -j"$(nproc)"
make install_sw
install -m 0644 "$WORK/openssl-$OPENSSL_VERSION/LICENSE.txt" "$OHOS_ASSETS/openssl/LICENSE.txt"

echo "== ICU $ICU_VERSION =="
curl "${CURL_OPTS[@]}" "$ICU_URL" -o "$WORK/icu.tar.gz"
echo "$ICU_SHA256  $WORK/icu.tar.gz" | sha256sum -c -
tar -xzf "$WORK/icu.tar.gz" -C "$WORK" --no-same-owner
mkdir -p "$WORK/icu-host" "$WORK/icu-target"

cd "$WORK/icu-host"
"$WORK/icu/source/configure" --disable-tests --disable-samples --disable-extras
make -j"$(nproc)"

cd "$WORK/icu-target"
CC="$TOOLCHAIN/aarch64-linux-ohos-gcc" CXX="$TOOLCHAIN/aarch64-linux-ohos-g++" \
AR="$TOOLCHAIN/aarch64-linux-ohos-ar" RANLIB="$TOOLCHAIN/aarch64-linux-ohos-ranlib" \
"$WORK/icu/source/configure" --host=aarch64-linux-gnu \
    --with-cross-build="$WORK/icu-host" \
    --disable-tests --disable-samples --disable-extras \
    --enable-static --disable-shared --libdir="$OHOS_ASSETS/icu/lib" \
    --prefix="$OHOS_ASSETS/icu"
make -j"$(nproc)"
make install
install -m 0644 "$WORK/icu/LICENSE" "$OHOS_ASSETS/icu/LICENSE"

# The cross build only consumes the headers and static archives. Remove
# command-line tools, docs, and package metadata installed by default.
rm -rf "$OHOS_ASSETS/openssl/share" "$OHOS_ASSETS/openssl/lib/pkgconfig"
rm -rf "$OHOS_ASSETS/icu/bin" "$OHOS_ASSETS/icu/share" "$OHOS_ASSETS/icu/lib/icu"

echo "== Verify =="
test -f "$OHOS_ASSETS/icu/include/unicode/ucurr.h"
test -f "$OHOS_ASSETS/icu/lib/libicuuc.a"
test -f "$OHOS_ASSETS/icu/lib/libicui18n.a"
test -f "$OHOS_ASSETS/icu/lib/libicudata.a"
test -f "$OHOS_ASSETS/openssl/include/openssl/ssl.h"
test -f "$OHOS_ASSETS/openssl/lib/libcrypto.a"
test -f "$OHOS_ASSETS/openssl/lib/libssl.a"
test -f "$OHOS_ASSETS/openssl/LICENSE.txt"
test -f "$OHOS_ASSETS/icu/LICENSE"
echo "OpenHarmony assets are ready under $OHOS_ASSETS"
