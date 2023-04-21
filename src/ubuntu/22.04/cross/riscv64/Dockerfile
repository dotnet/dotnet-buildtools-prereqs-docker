FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

# Remove LLVM linker and install binutils-riscv64-linux-gnu
RUN apt-get update \
    && apt-get remove -y \
        lld-15 \
    && apt-get autoremove -y \
    && apt-get install -y \
        binutils-riscv64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.riscv64.tar crossrootfs
