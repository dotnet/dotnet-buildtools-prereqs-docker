FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net9.0-local AS builder
ARG ROOTFS_DIR=/crossrootfs/x86

# We don't ship linux-x86 binaries, so we don't need to make a custom libc++ build for servicing concerns.
# We don't sanitize or instrument the linux-x64 build (as we don't ship it), so we don't need to build those runtime support libraries either.
RUN /scripts/eng/common/cross/build-rootfs.sh x86 xenial --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net9.0-local
ARG ROOTFS_DIR=/crossrootfs/x86

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
