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

ADD rootfs.riscv64.tar crossrootfs
