FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps-local

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DE19EB17684BA42D

# Install binutils-aarch64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
        clang-3.9 \
        libomp5 \
        libomp-dev \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.arm64.tar crossrootfs

# Configure system locale
RUN update-locale LANG=en_US.UTF-8
