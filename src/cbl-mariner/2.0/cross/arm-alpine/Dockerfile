FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm

RUN /scripts/eng/common/cross/build-rootfs.sh arm alpine3.13 --skipunmount


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-arm-local
ARG ROOTFS_DIR=/crossrootfs/arm

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
