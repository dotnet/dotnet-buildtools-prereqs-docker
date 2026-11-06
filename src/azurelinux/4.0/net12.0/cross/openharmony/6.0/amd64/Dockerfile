# OpenHarmony cross-compilation image: OpenHarmony Public SDK 6.0.0.47
# (API 20), static OpenSSL and ICU, and the aarch64-linux-ohos toolchain
# wrappers. The runtime CI leg uses the fixed paths below (see
# dotnet/runtime#136206). The SDK and assets are Apache-2.0/OSS; notices are
# copied into /opt/ohos-sdk.
FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-crossdeps-builder-amd64 AS builder

# Allow the three source downloads to come from an internal mirror.
ARG OHOS_SDK_URL=https://repo.huaweicloud.com/openharmony/os/6.0-Release/ohos-sdk-windows_linux-public.tar.gz
ARG OHOS_SDK_SHA=a315834ac133625efc912bd078f3e2b2550868d04aef1b5aa4f9679c8b3c9d8e
ARG OPENSSL_URL=https://github.com/openssl/openssl/releases/download/openssl-3.3.1/openssl-3.3.1.tar.gz
ARG OPENSSL_SHA256=777cd596284c883375a2a7a11bf5d2786fc5413255efab20c50d6ffe6d020b7e
ARG ICU_URL=https://github.com/unicode-org/icu/releases/download/release-75-1/icu4c-75_1-src.tgz
ARG ICU_SHA256=cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef

# The SDK is extracted with a Python helper that recreates the zip symlinks.
RUN tdnf install -y python3 tar gzip curl make perl-core gawk && tdnf clean all

COPY build-ohos.sh /scripts/build-ohos.sh
RUN chmod +x /scripts/build-ohos.sh && \
    OHOS_SDK_URL="$OHOS_SDK_URL" OHOS_SDK_SHA="$OHOS_SDK_SHA" \
    OPENSSL_URL="$OPENSSL_URL" OPENSSL_SHA256="$OPENSSL_SHA256" \
    ICU_URL="$ICU_URL" ICU_SHA256="$ICU_SHA256" \
    /scripts/build-ohos.sh

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-crossdeps-llvm-amd64

LABEL org.opencontainers.image.title="OpenHarmony cross-compilation image" \
      org.opencontainers.image.version="6.0.0.47" \
      org.opencontainers.image.licenses="Apache-2.0"

RUN tdnf install -y cmake ninja-build perl-core && tdnf clean all

COPY --from=builder /opt/ohos-sdk /opt/ohos-sdk
COPY --from=builder /opt/ohos-assets /opt/ohos-assets
COPY --from=builder /opt/ohos-toolchain /opt/ohos-toolchain

COPY LICENSE NOTICE THIRD-PARTY-NOTICES /opt/ohos-sdk/
COPY README.md /opt/ohos-sdk/README.md
RUN test -f /opt/ohos-sdk/LICENSE && test -f /opt/ohos-sdk/NOTICE

ENV OHOS_NDK_HOME=/opt/ohos-sdk/linux \
    OHOS_ASSETS=/opt/ohos-assets \
    OHOS_CMAKE_ARGS="-DCMAKE_ICU_DIR=/opt/ohos-assets/icu -DOPENSSL_ROOT_DIR=/opt/ohos-assets/openssl -DOPENSSL_INCLUDE_DIR=/opt/ohos-assets/openssl/include -DOPENSSL_CRYPTO_LIBRARY=/opt/ohos-assets/openssl/lib/libcrypto.a -DOPENSSL_SSL_LIBRARY=/opt/ohos-assets/openssl/lib/libssl.a" \
    PATH=/opt/ohos-toolchain/bin:$PATH \
    LD_LIBRARY_PATH=/opt/ohos-sdk/linux/native/llvm/lib
