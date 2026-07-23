ARG ROOTFS_DIR=/crossrootfs/x64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

# Install packages needed by the FreeBSD bootstrap scripts
RUN dnf install -y \
        automake \
        autoconf \
        gawk \
        libbsd-devel \
        libtool \
        m4 \
        xz-devel \
    && dnf clean all

RUN /scripts/eng/common/cross/build-rootfs.sh freebsd15 x64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
