FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-local

# TODO: remove this once debootstrap is available in the base repos.
COPY mariner-extended.repo /etc/yum.repos.d/

RUN tdnf install -y \
        # Rootfs build dependencies
        debootstrap \
        # LLVM build dependencies
        texinfo \
        binutils

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
    echo "f181a90697e3ea4b7782f1ee48314a570aef058505b4f3a0ab0611094ec13241 release-keys.asc" | sha256sum -c && \
    gpg --output release-keys.gpg --dearmor release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    LLVM_VERSION=12.0.1 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "6cc956d622a7d3d746de0d71d8ca616a6c291e2c561703ac7a9535f38b999955 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "129cb25cd13677aad951ce5c2deb0fe4afc1e9d98950f53b51bdcfb5a73afa0e llvm-project.src.tar.xz" | sha256sum -c && \
    gpg --keyring /release-keys.gpg --verify llvm-project.src.tar.xz.sig && \
    rm llvm-project.src.tar.xz.sig

# Build LLVM cross-toolchain (with support for targeting arm architectures)
RUN mkdir llvm-project.src && \
    tar -xf llvm-project.src.tar.xz --directory llvm-project.src --strip-components=1 && \
    rm llvm-project.src.tar.xz && \
    mkdir build && cd build && \
    cmake ../llvm-project.src/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="host;AArch64;ARM" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts
