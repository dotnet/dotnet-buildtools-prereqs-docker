ARG ROOTFS_DIR=/crossrootfs/x64

FROM  mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local AS builder
ARG ROOTFS_DIR

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

# Build the rootfs
RUN /scripts/eng/common/cross/build-rootfs.sh x64 illumos --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
