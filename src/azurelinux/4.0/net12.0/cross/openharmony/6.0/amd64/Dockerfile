# OpenHarmony cross-compilation image: OpenHarmony SDK/NDK, static OpenSSL and
# ICU, and the aarch64-linux-ohos toolchain wrappers. The runtime CI leg uses
# the fixed paths below (see dotnet/runtime#136206).
FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-crossdeps-builder-amd64 AS builder

# The SDK is extracted with a Python helper that recreates the zip symlinks.
RUN tdnf install -y python3 tar gzip curl make perl-core && tdnf clean all

COPY build-ohos.sh /scripts/build-ohos.sh
RUN chmod +x /scripts/build-ohos.sh && /scripts/build-ohos.sh

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-crossdeps-llvm-amd64

RUN tdnf install -y cmake ninja-build perl-core && tdnf clean all

COPY --from=builder /opt/ohos-sdk /opt/ohos-sdk
COPY --from=builder /opt/ohos-assets /opt/ohos-assets
COPY --from=builder /opt/ohos-toolchain /opt/ohos-toolchain

ENV OHOS_NDK_HOME=/opt/ohos-sdk/linux \
    OHOS_ASSETS=/opt/ohos-assets \
    OHOS_CMAKE_ARGS="-DCMAKE_ICU_DIR=/opt/ohos-assets/icu -DOPENSSL_ROOT_DIR=/opt/ohos-assets/openssl -DOPENSSL_INCLUDE_DIR=/opt/ohos-assets/openssl/include -DOPENSSL_CRYPTO_LIBRARY=/opt/ohos-assets/openssl/lib/libcrypto.a -DOPENSSL_SSL_LIBRARY=/opt/ohos-assets/openssl/lib/libssl.a" \
    PATH=/opt/ohos-toolchain/bin:$PATH \
    LD_LIBRARY_PATH=/opt/ohos-sdk/linux/native/llvm/lib
