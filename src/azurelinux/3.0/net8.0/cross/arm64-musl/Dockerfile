ARG ROOTFS_DIR=/crossrootfs/arm64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt /scripts/eng/common/cross/build-rootfs.sh arm64 alpine3.13 --skipunmount --skipemulation


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
