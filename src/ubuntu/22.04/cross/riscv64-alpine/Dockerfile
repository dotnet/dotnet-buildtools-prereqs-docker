ARG ROOTFS_DIR=/crossrootfs/riscv64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local as builder

ARG ROOTFS_DIR

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

# Build the rootfs
RUN /scripts/eng/common/cross/build-rootfs.sh riscv64 alpine --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

RUN cd /tmp \
    && wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.gz \
    && tar -xf binutils-2.40.tar.gz \
    && cd binutils-2.40 \
    && ./configure \
       --disable-werror \
       --target=riscv64-alpine-linux-musl \
       --prefix=/usr \
       --libdir=/lib \
       --disable-multilib \
       --with-sysroot=riscv64-alpine-linux-musl \
       --enable-gold=yes \
       --enable-plugins=yes \
       --program-prefix=riscv64-alpine-linux-musl- \
    && make \
    && make install \
    && cd .. \
    && rm -r *

ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
