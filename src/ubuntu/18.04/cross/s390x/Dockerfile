FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps-local

# Install binutils-s390x-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-s390x-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.s390x.tar crossrootfs
