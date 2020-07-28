FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps

# Install binutils-powerpc64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-powerpc64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.ppc64.tar crossrootfs
