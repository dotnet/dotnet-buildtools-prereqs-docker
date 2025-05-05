FROM mcr.microsoft.com/azurelinux/base/core:3.0 AS builder

RUN tdnf update -y && \
    tdnf install -y \
        # Common dependencies
        ca-certificates \
        git \
        tar \
        util-linux \
        wget \
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
        zlib-devel

# Steps copied (mostly, changed target archs) from crossdeps Dockerfile: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/blob/main/src/azurelinux/3.0/net10.0/crossdeps-builder/amd64/Dockerfile
# 1. Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "972d9449ebf7de947a1dff7f25edf8eea7963e4f7501b20d29328df55162f3b8 release-keys.asc" | sha256sum -c && \
    gpg --import release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    LLVM_VERSION=20.1.4 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "ae3d2c245f1074dec671c8472ebc852603a52aebd7191bd08346411dc5f9b352 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "a95365b02536ed4aef29b325c205dd89c268cba41503ab2fc05f81418613ab63 llvm-project.src.tar.xz" | sha256sum -c && \
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


FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Common dependencies
        ca-certificates \
        git \
        tar \
        util-linux \
        wget \
        # Runtime dependencies
        icu

# Install LLVM that we built from source
COPY --from=builder /opt/llvm /usr/local
