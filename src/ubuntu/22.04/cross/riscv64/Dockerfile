FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local as builder

ARG ROOTFS_DIR=/crossrootfs/riscv64

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

# Build the rootfs
RUN /scripts/eng/common/cross/build-rootfs.sh riscv64 noble --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

ARG ROOTFS_DIR=/crossrootfs/riscv64

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
