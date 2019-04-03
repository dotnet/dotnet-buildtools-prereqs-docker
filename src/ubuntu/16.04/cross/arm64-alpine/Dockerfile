FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04-crossdeps

# Install binutils-aarch64-linux-gnu
#
# Also install bison. This is required to build musl-cross-make
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
        bison \
    && rm -rf /var/lib/apt/lists/*

# Workaround to build a functioning ld.gold which can link for linux-musl arm64
RUN cd /tmp \
    && wget https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz \
    && tar -xf binutils-2.31.1.tar.gz \
    && cd binutils-2.31.1 \
    && ./configure --disable-werror --target=aarch64-alpine-linux-musl --prefix=/usr --libdir=/lib --disable-multilib --with-sysroot=aarch64-alpine-linux-musl --enable-gold=yes --enable-plugins=yes --program-prefix=aarch64-alpine-linux-musl- \
    && make \
    && make install \
    && cd .. \
    && rm -r *

ADD rootfs.arm64.tar crossrootfs
