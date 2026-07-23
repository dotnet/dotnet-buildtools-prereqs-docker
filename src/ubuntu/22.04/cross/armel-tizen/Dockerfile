ARG ROOTFS_DIR=/crossrootfs/armel

# Arcade rootfs cross-build scripts, provided as a separate image so they can be copied
# in without requiring the repo root as the Docker build context. See eng/cross-scripts.Dockerfile.
FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cross-scripts-amd64 AS cross-scripts

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps AS builder
ARG ROOTFS_DIR

# Copy arcade scripts used to build rootfs
COPY --from=cross-scripts /eng/common/cross/ /scripts/eng/common/cross/

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
