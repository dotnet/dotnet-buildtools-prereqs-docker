FROM mcr.microsoft.com/azurelinux/core:4 AS builder

RUN dnf update -y && \
    dnf install -y \
        # Common dependencies
        bzip2 \
        ca-certificates \
        git \
        gnupg2 \
        openssl \
        tar \
        util-linux \
        wget2-wget \
        xz \
        # LLVM Build tools
        binutils \
        clang \
        gcc \
        make \
        cmake \
        diffutils \
        glibc-devel \
        kernel-headers \
        texinfo \
        zlib-ng-compat-devel \
    && dnf clean all

# Steps copied (mostly, changed target archs) from crossdeps Dockerfile: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/blob/main/src/azurelinux/4.0/net12.0/crossdeps-builder/amd64/Dockerfile
# 1. Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "f38bd19b7f2d22cafa755841e6ce9375b9a2e6d41f7b974e4953d6b084839001 release-keys.asc" | sha256sum -c && \
    gpg --import release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    LLVM_VERSION=23.1.5 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "c8ddd0ad6c8c5eb0f902e54f19580340e3c701a53fc7e5890f69851724305382 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "bef140a1a96994029153dca8c00b1750b9a5a764fb9db2dc68d7bb40e8a29e8a llvm-project.src.tar.xz" | sha256sum -c && \
    gpg --verify llvm-project.src.tar.xz.sig && \
    rm llvm-project.src.tar.xz.sig

# Build LLVM cross-toolchain (with support for targeting x86/x64, arm64, arm, s390x and ppc64le architectures)
RUN mkdir llvm-project.src && \
    tar -xf llvm-project.src.tar.xz --directory llvm-project.src --strip-components=1 && \
    rm llvm-project.src.tar.xz && \
    mkdir build && cd build && \
    cmake ../llvm-project.src/llvm \
        -DCMAKE_INSTALL_PREFIX=/opt/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_TARGETS_TO_BUILD="X86;AArch64;ARM" \
        -Wno-dev && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install


FROM mcr.microsoft.com/azurelinux/core:4

RUN dnf update -y && \
    dnf install -y \
        # Common dependencies
        bzip2 \
        ca-certificates \
        git \
        openssl \
        tar \
        util-linux \
        pam \
        sudo \
        wget2-wget \
        xz \
        shadow-utils \
        # Runtime dependencies
        icu

# Install LLVM that we built from source
COPY --from=builder /opt/llvm /usr/local
