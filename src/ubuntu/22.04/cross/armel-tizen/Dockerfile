FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local AS builder
ARG ROOTFS_DIR=/crossrootfs/armel

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --branch feature/build-rootfs-freestanding --single-branch https://github.com/am11/arcade /scripts

RUN /scripts/eng/common/cross/tizen-build-rootfs.sh armel

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local
ARG ROOTFS_DIR=/crossrootfs/armel

# Install binutils-arm-linux-gnueabi
RUN apt-get update \
    && apt-get install -y \
        binutils-arm-linux-gnueabi \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
