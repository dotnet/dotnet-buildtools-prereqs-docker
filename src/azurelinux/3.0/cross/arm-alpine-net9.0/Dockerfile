FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net9.0-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm

RUN /scripts/eng/common/cross/build-rootfs.sh arm alpine3.13 --skipunmount


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net9.0-local
ARG ROOTFS_DIR=/crossrootfs/arm

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
