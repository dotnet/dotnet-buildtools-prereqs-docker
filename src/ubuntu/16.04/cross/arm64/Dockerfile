FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04-crossdeps

# Install binutils-aarch64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.arm64.tar crossrootfs
