ARG ROOTFS_DIR=/crossrootfs/s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local as builder

ARG ROOTFS_DIR

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

# Build the rootfs
RUN /scripts/eng/common/cross/build-rootfs.sh s390x alpine --skipunmount

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

ARG ROOTFS_DIR

RUN cd /tmp \
    && wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.gz \
    && tar -xf binutils-2.40.tar.gz \
    && cd binutils-2.40 \
    && ./configure \
       --disable-werror \
       --target=s390x-alpine-linux-musl \
       --prefix=/usr \
       --libdir=/lib \
       --disable-multilib \
       --with-sysroot=s390x-alpine-linux-musl \
       --enable-gold=yes \
       --enable-plugins=yes \
       --program-prefix=s390x-alpine-linux-musl- \
    && make \
    && make install \
    && cd .. \
    && rm -r *

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
