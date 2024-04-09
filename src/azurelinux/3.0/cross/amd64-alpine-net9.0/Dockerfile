FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net9.0-local AS builder
ARG ROOTFS_DIR=/crossrootfs/x64

RUN /scripts/eng/common/cross/build-rootfs.sh x64 alpine3.13 --skipunmount


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net9.0-local
ARG ROOTFS_DIR=/crossrootfs/x64

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
