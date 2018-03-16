FROM microsoft/dotnet-buildtools-prereqs:ubuntu-16.04-crossdeps

# Install binutils-arm-linux-gnueabihf
RUN apt-get update \
    && apt-get install -y \
        binutils-arm-linux-gnueabihf \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.tar crossrootfs
