FROM microsoft/dotnet-buildtools-prereqs:ubuntu-16.04-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        binfmt-support \
        binutils-arm-linux-gnueabihf \
        cmake \
        debootstrap \
        make \
        qemu \
        qemu-user-static \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main" >> /etc/apt/sources.list.d/llvm.list \
    && echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main" >> /etc/apt/sources.list.d/llvm.list \
    && wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        llvm-3.9 \
        clang-3.9 \
        liblldb-3.9-dev \
        lldb-3.9 \
        python-lldb-3.9 \
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
