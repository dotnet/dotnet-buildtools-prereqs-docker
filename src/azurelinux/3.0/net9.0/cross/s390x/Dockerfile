FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR=/crossrootfs/s390x

RUN /scripts/eng/common/cross/build-rootfs.sh bionic s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-local
ARG ROOTFS_DIR=/crossrootfs/s390x

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"