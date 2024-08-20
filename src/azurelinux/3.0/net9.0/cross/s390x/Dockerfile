ARG ROOTFS_DIR=/crossrootfs/s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh bionic s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-llvm-local
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
