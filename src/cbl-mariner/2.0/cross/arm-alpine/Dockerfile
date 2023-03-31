FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm

RUN /scripts/eng/common/cross/build-rootfs.sh arm alpine3.13 --skipunmount

# Add numa headers (numactl-dev is not available on Alpine 3.13 arm)
# 2.0.14 matches the version available on Alpine 3.13 amd64.
RUN NUMACTL_VERSION=2.0.14 && \
    wget -O numactl.tar.gz https://github.com/numactl/numactl/archive/v${NUMACTL_VERSION}.tar.gz && \
    echo "1ee27abd07ff6ba140aaf9bc6379b37825e54496e01d6f7343330cf1a4487035 numactl.tar.gz" | sha256sum -c && \
    mkdir numactl && \
    tar -xf numactl.tar.gz --directory numactl --strip-components=1 && \
    rm numactl.tar.gz && \
    cd numactl && \
    mkdir $ROOTFS_DIR/usr/local/include/ && \
    cp numacompat1.h numa.h numaif.h $ROOTFS_DIR/usr/local/include/


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-arm-local
ARG ROOTFS_DIR=/crossrootfs/arm

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
