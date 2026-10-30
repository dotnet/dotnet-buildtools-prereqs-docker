# OpenHarmony cross-compilation image

This image provides the OpenHarmony Public SDK 6.0.0.47 (API 20), static
OpenSSL 3.3.1 and ICU 75.1 builds, and the aarch64-linux-ohos toolchain
wrappers. It is the image used by the OpenHarmony runtime-community leg
(see dotnet/runtime#136206).

## Contents

| Path | Contents |
|------|----------|
| `/opt/ohos-sdk/linux` | OpenHarmony SDK/NDK 6.0.0.47 (API 20) |
| `/opt/ohos-assets/openssl` | static OpenSSL 3.3.1 |
| `/opt/ohos-assets/icu` | static ICU 75.1 |
| `/opt/ohos-toolchain/bin` | `aarch64-linux-ohos-*` toolchain wrappers |

## Source and license

The SDK is downloaded from the OpenHarmony 6.0-Release mirror:

```text
https://repo.huaweicloud.com/openharmony/os/6.0-Release/ohos-sdk-windows_linux-public.tar.gz
SHA256 a315834ac133625efc912bd078f3e2b2550868d04aef1b5aa4f9679c8b3c9d8e
```

The OpenHarmony Public SDK is licensed under the Apache License, Version 2.0.
The license text is at `/opt/ohos-sdk/LICENSE`; SDK component notices are
preserved under `/opt/ohos-sdk/linux/*/NOTICE.txt`.

Third-party notices for OpenSSL, ICU, and the base images are in
`/opt/ohos-sdk/THIRD-PARTY-NOTICES`.

This image does **not** contain the Huawei HarmonyOS SDK, Apple SDK, or
Android SDK. Those SDKs have separate licenses and are not redistributed here.

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
SDK, assets, and toolchain into the final image.
