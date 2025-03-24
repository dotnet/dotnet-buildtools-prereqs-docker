FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf install -y \
        # Common utilities
        ca-certificates \
        git \
        tar \
        wget \
        # LLVM build dependencies
        binutils \
        clang \
        cmake \
        diffutils \
        glibc-devel \
        kernel-headers \
        texinfo \
        # Rootfs build dependencies
        bzip2-devel \
        debootstrap \
        libarchive-devel \
        openssl-devel

# dependencies which are installed from extended repo require additional setup
RUN wget https://packages.microsoft.com/cbl-mariner/2.0/prod/extended/x86_64/config.repo -O /etc/yum.repos.d/mariner-extended.repo && \
    tdnf makecache && \
    tdnf install -y \
        libbsd-devel

# Obtain ubuntu package signing key (for use by debootstrap)
# 1. Add public key used to sign the ubuntu keyring
COPY dimitri_john_ledkov.asc .
RUN gpg --output dimitri_john_ledkov.gpg --dearmor dimitri_john_ledkov.asc && \
    rm dimitri_john_ledkov.asc && \
# 2. Download the ubuntu keyrings
    wget https://mirrors.edge.kernel.org/ubuntu/pool/main/u/ubuntu-keyring/ubuntu-keyring_2021.03.26.tar.gz && \
    echo "492eed5c06408c6f632577adb0796130af5d6542013ef418f47187a209e49bb1 ubuntu-keyring_2021.03.26.tar.gz" | sha256sum -c && \
    tar xf ubuntu-keyring_2021.03.26.tar.gz && \
    rm ubuntu-keyring_2021.03.26.tar.gz && \
# 3. Verify keyrings
    pushd ubuntu-keyring-2021.03.26 && \
    gpg --keyring /dimitri_john_ledkov.gpg --output SHA512SUMS.txt --decrypt SHA512SUMS.txt.asc && \
    rm /dimitri_john_ledkov.gpg && \
    sha512sum -c SHA512SUMS.txt && \
# 4. Install the needed keyring and delete the rest
    mkdir -p /usr/share/keyrings && \
    mv keyrings/ubuntu-archive-keyring.gpg /usr/share/keyrings && \
    popd && \
    rm -r ubuntu-keyring-2021.03.26

# 1. Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "972d9449ebf7de947a1dff7f25edf8eea7963e4f7501b20d29328df55162f3b8 release-keys.asc" | sha256sum -c && \
    gpg --output release-keys.gpg --dearmor release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    LLVM_VERSION=16.0.0 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "2fa1ae520c6756fb53ede6bd9359f7e40fe5d0bfdbd04c359f3b8ce22958a896 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "9a56d906a2c81f16f06efc493a646d497c53c2f4f28f0cb1f3c8da7f74350254 llvm-project.src.tar.xz" | sha256sum -c && \
    gpg --keyring /release-keys.gpg --verify llvm-project.src.tar.xz.sig && \
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
        -DLLVM_TARGETS_TO_BUILD="X86;AArch64;ARM;PowerPC;SystemZ" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

ENV PATH="/opt/llvm/bin:$PATH"

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

