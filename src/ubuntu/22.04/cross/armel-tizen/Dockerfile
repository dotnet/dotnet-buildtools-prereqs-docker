ARG ROOTFS_DIR=/crossrootfs/armel

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps AS builder
ARG ROOTFS_DIR

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

RUN /scripts/eng/common/cross/tizen-build-rootfs.sh armel

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps
ARG ROOTFS_DIR

# Install binutils-arm-linux-gnueabi
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        binutils-arm-linux-gnueabi \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
