FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-coredeps-local

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
        texinfo \
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

# Install debian ports package signing keys
RUN wget https://www.ports.debian.org/archive_2024.key && \
    echo "5dba676e1c2b14882a39a93d002f77a11464d3c0ddce503a7601202a34fd5d48f1fead96fd8f975cfed00f525444b02aaf0c1c222a44c8759cbb04e55408f6d3 archive_2024.key" | sha512sum -c && \
    gpg --output /usr/share/keyrings/debian-ports-archive-keyring.gpg --dearmor archive_2024.key
