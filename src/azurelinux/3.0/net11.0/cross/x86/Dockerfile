ARG ROOTFS_DIR=/crossrootfs/x86

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

# We don't ship linux-x86 binaries, so we don't need to make a custom libc++ build for servicing concerns.
# We don't sanitize or instrument the linux-x64 build (as we don't ship it), so we don't need to build those runtime support libraries either.
RUN /scripts/eng/common/cross/build-rootfs.sh x86 bionic --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
