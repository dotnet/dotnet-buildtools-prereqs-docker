FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps

# Install bison. This is required to build musl-cross-make
RUN apt-get update \
    && apt-get install -y \
        bison \
    && rm -rf /var/lib/apt/lists/*

# Workaround to build a functioning ld.gold which can link for linux-musl arm
RUN cd /tmp \
    && wget https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz \
    && tar -xf binutils-2.31.1.tar.gz \
    && cd binutils-2.31.1 \
    && ./configure \
        --disable-werror \
        --target=armv7-alpine-linux-musleabihf \
        --prefix=/usr \
        --libdir=/lib \
        --disable-multilib \
        --with-sysroot=armv7-alpine-linux-musleabihf \
        --enable-gold=yes \
        --enable-plugins=yes \
        --program-prefix=armv7-alpine-linux-musleabihf- \
    && make \
    && make install \
    && cd .. \
    && rm -r *

ADD rootfs.arm.tar crossrootfs
