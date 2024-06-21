FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

RUN apt-get update \
    && apt-get install -y \
        qemu \
        qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

# Build the rootfs
RUN /scripts/eng/common/cross/build-rootfs.sh arm jammy lldb14 --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local
ARG ROOTFS_DIR=/crossrootfs/arm

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
