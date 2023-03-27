FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps-local

# Install binutils-arm-linux-gnueabi
RUN apt-get update \
    && apt-get install -y \
        binutils-arm-linux-gnueabi \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.armel.tar crossrootfs
