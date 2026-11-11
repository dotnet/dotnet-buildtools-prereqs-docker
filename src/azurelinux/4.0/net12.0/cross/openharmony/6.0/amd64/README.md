# OpenHarmony cross-compilation image

This image provides the OpenHarmony Public SDK 6.0.0.47 (API 20), static
OpenSSL 3.3.1 and ICU 75.1 builds, and the aarch64-linux-ohos toolchain
wrappers. It is the image used by the OpenHarmony runtime-community leg
(see dotnet/runtime#136206).

## Contents

| Path | Contents |
|------|----------|
| `/opt/ohos-sdk/linux/native` | OpenHarmony SDK/NDK 6.0.0.47 (API 20), Linux x86_64 host + aarch64-linux-ohos target |
| `/opt/ohos-assets/openssl` | static OpenSSL 3.3.1 |
| `/opt/ohos-assets/icu` | static ICU 75.1 |
| `/opt/ohos-toolchain/bin` | `aarch64-linux-ohos-*` toolchain wrappers |

## Image trimming and size

The SDK tarball contains host-specific payloads. `linux/` is the Linux x86_64
host SDK and `ohos/` is an OpenHarmony host SDK; the target is
`aarch64-linux-ohos`, whose compiler and sysroot live under `linux/native`.
The image therefore copies and retains only the Linux-host native component.
The `ohos/` payload and the non-native Linux SDK zips are not used by this
cross-compilation image.

Unused SDK documentation, bundled CMake, non-aarch64 target runtimes, LLVM
analysis/debug tools, and OpenSSL/ICU command-line/docs payloads are removed.
`native/llvm/include` is retained because the SDK compiler uses its C++
standard-library headers during host ICU builds.

Measured with both `docker image inspect` and `docker save` on the final image:

```text
docker image inspect:       2,294,497,341 bytes
docker save (uncompressed): 2,294,521,856 bytes
final image:                ~2.29 GB (2.14 GiB)
```

## Source and license

The SDK defaults to the internal mirror used by the prereqs build:

```text
https://netcorenativeassets.blob.core.windows.net/resource-packages/external/OpenHarmony/ohos-sdk-windows_linux-public-6.0.tar.gz
SHA256 a315834ac133625efc912bd078f3e2b2550868d04aef1b5aa4f9679c8b3c9d8e
```

The public OpenHarmony 6.0-Release URL is kept as a fallback:

```text
https://repo.huaweicloud.com/openharmony/os/6.0-Release/ohos-sdk-windows_linux-public.tar.gz
```

The OpenHarmony Public SDK is licensed under the Apache License, Version 2.0.
The license text is at `/opt/ohos-sdk/LICENSE`; SDK component notices are
preserved under `/opt/ohos-sdk/linux/*/NOTICE.txt`.

Third-party notices for OpenSSL, ICU, and the base images are in
`/opt/ohos-sdk/THIRD-PARTY-NOTICES`.

This image does **not** contain the Huawei HarmonyOS SDK, Apple SDK, or
Android SDK. Those SDKs have separate licenses and are not redistributed here.

## Pinned versions

| Component | Version |
|-----------|---------|
| OpenHarmony Public SDK | 6.0.0.47 (API 20) |
| OpenSSL | 3.3.1 (static, `no-shared`) |
| ICU | 75.1 (static) |

## Internal mirror / network isolation

Network isolation applies to all three downloads. The SDK is already mirrored
and is the default; OpenSSL and ICU still use their public release URLs until
they are uploaded to the same storage account. All three can be redirected
without editing the script:

```bash
docker build \
  --build-arg OHOS_SDK_URL=https://netcorenativeassets.blob.core.windows.net/resource-packages/external/OpenHarmony/ohos-sdk-windows_linux-public-6.0.tar.gz \
  --build-arg OPENSSL_URL=https://<storage>/.../openssl-3.3.1.tar.gz \
  --build-arg ICU_URL=https://<storage>/.../icu4c-75_1-src.tgz \
  -t azurelinux-4.0-net12.0-cross-openharmony-6.0-amd64 .
```

Every download is verified against the SHA256 pinned in `build-ohos.sh`, so a
changed mirror fails loudly instead of silently changing the image contents.

## Image tag

The directory path produces the tag:

```text
azurelinux-4.0-net12.0-cross-openharmony-6.0-amd64
```

The image pins the exact SDK version `6.0.0.47` even though the tag uses the
major/minor `6.0` name.

## Build

```bash
docker build -t azurelinux-4.0-net12.0-cross-openharmony-6.0-amd64 .
```

The builder downloads and verifies the SDK, OpenSSL, and ICU sources by
SHA256, builds OpenSSL and ICU with the OpenHarmony toolchain, and copies the
native SDK component, assets, and toolchain into the final image.
