FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

RUN cd /tmp \
    && wget https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz \
    && tar -xf binutils-2.39.tar.gz \
    && cd binutils-2.39 \
    && ./configure \
       --disable-werror \
       --target=armv7-alpine-linux-musl \
       --prefix=/usr \
       --libdir=/lib \
       --disable-multilib \
       --with-sysroot=armv7-alpine-linux-musl \
       --enable-gold=yes \
       --enable-plugins=yes \
       --program-prefix=armv7-alpine-linux-musl- \
    && make \
    && make install \
    && cd .. \
    && rm -r *

ADD rootfs.arm.tar crossrootfs
