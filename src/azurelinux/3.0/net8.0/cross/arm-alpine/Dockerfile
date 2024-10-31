ARG ROOTFS_DIR=/crossrootfs/arm

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-builder AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh arm alpine3.13 --skipunmount


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-llvm
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
