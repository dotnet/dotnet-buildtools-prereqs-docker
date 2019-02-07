FROM microsoft/dotnet-buildtools-prereqs:ubuntu-16.04-crossdeps

# Install binutils-aarch64-linux-gnu
#
# Also install bison. This is required to build musl-cross-make
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
        bison \
    && rm -rf /var/lib/apt/lists/*

# Workaround to build a functioning ld.gold which can link for linux-musl arm64
RUN cd /tmp && git clone https://github.com/richfelker/musl-cross-make.git

RUN echo "TARGET = aarch64-alpine-linux-musl" >> /tmp/musl-cross-make/config.mak
RUN echo "OUTPUT = /usr" >> /tmp/musl-cross-make/config.mak
RUN echo "BINUTILS_CONFIG=--enable-gold=yes --program-prefix=aarch64-alpine-linux-musl-" >> /tmp/musl-cross-make/config.mak

RUN cd /tmp/musl-cross-make && make
RUN cd /tmp/musl-cross-make && make install

ADD rootfs.arm64.tar crossrootfs
