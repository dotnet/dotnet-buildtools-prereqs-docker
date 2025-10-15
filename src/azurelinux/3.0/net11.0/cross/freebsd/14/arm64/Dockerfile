ARG ROOTFS_DIR=/crossrootfs/arm64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

# Install packages needed by the FreeBSD bootstrap scripts
RUN tdnf install -y \
      awk \
      m4 \
    # The xz package in Azure Linux 3.0 doesn't provide liblzma.so, so we need to create a symlink to liblzma.so.5
    # so the FreeBSD bootstrap can find it. See https://github.com/microsoft/azurelinux/issues/9217
    && ln -s /usr/lib/liblzma.so.5 /usr/lib/liblzma.so

RUN /scripts/eng/common/cross/build-rootfs.sh freebsd14 arm64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
