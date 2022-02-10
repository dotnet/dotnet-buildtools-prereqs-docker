FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps

# Install binutils-powerpc64le-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-powerpc64le-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.ppc64le.tar crossrootfs
