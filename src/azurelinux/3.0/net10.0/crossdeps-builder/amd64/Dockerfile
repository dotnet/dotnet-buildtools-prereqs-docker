FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf install -y \
        # Common utilities
        ca-certificates \
        git \
        tar \
        wget \
        # LLVM build dependencies
        binutils \
        clang \
        gcc \
        make \
        cmake \
        diffutils \
        glibc-devel \
        kernel-headers \
        texinfo \
        zlib-devel \
        # Rootfs build dependencies
        bzip2-devel \
        debootstrap \
        libarchive-devel \
        openssl-devel

# dependencies which are installed from extended repo require additional setup
RUN wget https://packages.microsoft.com/azurelinux/3.0/prod/extended/x86_64/config.repo -O /etc/yum.repos.d/azurelinux-extended.repo && \
    tdnf makecache && \
    tdnf install -y \
        libbsd-devel

# Obtain ubuntu package signing key (for use by debootstrap)
# 1. Add public key used to sign the ubuntu keyring
COPY dimitri_john_ledkov.asc .
RUN gpg --import dimitri_john_ledkov.asc && \
    rm dimitri_john_ledkov.asc && \
# 2. Download the ubuntu keyrings
    wget https://mirrors.edge.kernel.org/ubuntu/pool/main/u/ubuntu-keyring/ubuntu-keyring_2023.11.28.1.tar.xz && \
    echo "aecd455ae15561371d6e454f121f079f0641d5e1b579a5563a2bc363fc74aa2e ubuntu-keyring_2023.11.28.1.tar.xz" | sha256sum -c && \
    tar xf ubuntu-keyring_2023.11.28.1.tar.xz && \
    rm ubuntu-keyring_2023.11.28.1.tar.xz && \
# 3. Verify keyrings
    pushd ubuntu-keyring && \
    gpg --output SHA512SUMS.txt --decrypt SHA512SUMS.txt.asc && \
    sha512sum -c SHA512SUMS.txt && \
# 4. Install the needed keyring and delete the rest
    mkdir -p /usr/share/keyrings && \
    mv keyrings/ubuntu-archive-keyring.gpg /usr/share/keyrings && \
    wget -qO- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x871920D1991BC93C" | gpg --dearmor > /usr/share/keyrings/ubuntu-archive-removed-keys.gpg && \
    popd && \
    rm -r ubuntu-keyring

# 1. Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "972d9449ebf7de947a1dff7f25edf8eea7963e4f7501b20d29328df55162f3b8 release-keys.asc" | sha256sum -c && \
    gpg --import release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    LLVM_VERSION=19.1.6 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "64ed72651676c260308358b9a6d38846eaaa99addc6af504b899fedc605d5a9c llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "e3f79317adaa9196d2cfffe1c869d7c100b7540832bc44fe0d3f44a12861fa34 llvm-project.src.tar.xz" | sha256sum -c && \
    gpg --verify llvm-project.src.tar.xz.sig && \
    rm llvm-project.src.tar.xz.sig

# Build LLVM cross-toolchain (with support for targeting x86/x64, arm64, arm, s390x and ppc64le architectures)
RUN mkdir llvm-project.src && \
    tar -xf llvm-project.src.tar.xz --directory llvm-project.src --strip-components=1 && \
    rm llvm-project.src.tar.xz && \
    mkdir build && cd build && \
    cmake ../llvm-project.src/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_TARGETS_TO_BUILD="X86;AArch64;ARM;PowerPC;RISCV;SystemZ;LoongArch" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts 
