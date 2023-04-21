FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

# Install binutils-riscv64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-riscv64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.riscv64.tar crossrootfs
