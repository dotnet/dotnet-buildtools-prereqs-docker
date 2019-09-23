FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main' \
    && apt-get update \
    && apt-get install -y \
        binfmt-support \
        binutils-arm-linux-gnueabihf \
        cmake \
        debootstrap \
        gdb \
        make \
        qemu \
        qemu-user-static \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        llvm-5.0 \
        clang-5.0 \
        liblldb-5.0-dev \
        lldb-5.0 \
        python-lldb-5.0 \
    && rm -rf /var/lib/apt/lists/*

# Install x86_arm crossgen dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        libc6:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        multiarch-support \
    && rm -rf /var/lib/apt/lists/*
