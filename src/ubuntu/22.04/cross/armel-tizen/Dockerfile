ARG ROOTFS_DIR=/crossrootfs/armel

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps AS builder
ARG ROOTFS_DIR

# Obtain arcade scripts used to build rootfs
ARG ARCADE_COMMIT=e5f974ba880c3da69932191c665e90ee64e8da26
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git init /scripts && \
    git -C /scripts fetch --depth 1 https://github.com/dotnet/arcade ${ARCADE_COMMIT} && \
    git -C /scripts checkout --detach FETCH_HEAD

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
