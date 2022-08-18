FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ jammy main' \
    && apt-get update \
    && apt-get install -y \
        binfmt-support \
        binutils-arm-linux-gnueabihf \
        bison \
        bisonc++ \
        build-essential \
        cmake \
        cpio \
        debootstrap \
        flex \
        gdb \
        make \
        nasm \
        qemu \
        qemu-user-static \
        rpm2cpio \
        libbz2-dev \
        libz-dev \
        liblzma-dev \
        libarchive-dev \
        libbsd-dev \
        libmpc-dev \
        libxml2-utils \
        libzstd-dev \
    && rm -rf /var/lib/apt/lists/*

# install llvm-toolchain v15 using official script
RUN wget -O- https://apt.llvm.org/llvm.sh | bash -s -- 15 \
        clang \
        clang-tools \
        liblldb-dev \
        lld \
        lldb \
        llvm \
        python3-lldb \
    && rm -rf /var/lib/apt/lists/*
