ARG ROOTFS_DIR=/crossrootfs/ppc64le

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-builder AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh bionic ppc64le

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-llvm
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
