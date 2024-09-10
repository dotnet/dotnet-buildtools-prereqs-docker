FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-coredeps-local

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' \
    && apt-get update \
    && apt-get install -y \
        binfmt-support \
        binutils-arm-linux-gnueabihf \
        build-essential \
        cmake \
        cpio \
        debootstrap \
        flex \
        gdb \
        libarchive-dev \
        libbz2-dev \
        libbsd-dev \
        liblzma-dev \
        libmpc-dev \
        libxml2-utils \
        libz-dev \
        make \
        pigz \
        qemu \
        qemu-user-static \
        rpm2cpio \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        clang-9 \
        clang-tools-9 \
        liblldb-6.0-dev \
        lld-9 \
        lldb-6.0 \
        llvm-9 \
        python-lldb-6.0 \
    && rm -rf /var/lib/apt/lists/*

