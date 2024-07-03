ARG ROOTFS_DIR=/crossrootfs/arm64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net8.0-local AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh arm64 alpine3.13 --skipunmount


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net8.0-local
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
