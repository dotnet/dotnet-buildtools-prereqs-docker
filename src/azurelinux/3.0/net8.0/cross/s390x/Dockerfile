ARG ROOTFS_DIR=/crossrootfs/s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh bionic s390x

# build ld from binutils since llvm's lld only supports s390x since 18.0 but we're using 16.0
# this can be removed once crossdeps-builder switches to llvm 18.0
RUN tdnf install -y awk && \
    wget https://sourceware.org/pub/binutils/snapshots/binutils-2.41.90.tar.xz -O binutils.tar.xz && \
    echo "6e990c6e40000acedb9928fa6b6a32a164f3119740a95c40e7a85c6461dbdda5 binutils.tar.xz" | sha256sum -c && \
    mkdir binutils.src && \
    tar -xf binutils.tar.xz --directory=binutils.src --strip-components=1 && \
    cd binutils.src && \
    ./configure --target=s390x-linux-gnu --prefix=/binutils.install --disable-nls --disable-werror && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install -C ld

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
COPY --from=builder /binutils.install/s390x-linux-gnu/bin/ld /usr/local/bin/s390x-linux-gnu-ld
