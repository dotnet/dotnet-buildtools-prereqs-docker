FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Common utilities
        ca-certificates \
        git \
        jq \
        gzip \
        shadow-utils \
        tar \
        unzip \
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
        libarchive-devel \
        openssl-devel \
        python3

ENV ROOTFS_PIP_HOME=/usr/local/share/rootfs

COPY <<ROOTFS_PIP_REQUIREMENTS /tmp/rootfs-pip-requirements.txt
aiohappyeyeballs==2.6.2 --hash=sha256:4708045e2d7a6c6bdf8aafa8ed39649eaf926a4543b54560659129e3365953c4
aiohttp==3.13.5 --hash=sha256:b18f31b80d5a33661e08c89e202edabf1986e9b49c42b4504371daeaa11b47c1
aiosignal==1.4.0 --hash=sha256:053243f8b92b990551949e63930a839ff0cf0b0ebbe0597b0f3fb19e1a0fe82e
attrs==26.1.0 --hash=sha256:c647aa4a12dfbad9333ca4e71fe62ddc36f4e63b2d260a37a8b83d2f043ac309
frozenlist==1.8.0 --hash=sha256:0c18a16eab41e82c295618a77502e17b195883241c563b00f0aa5106fc4eaa0d
idna==3.15 --hash=sha256:048adeaf8c2d788c40fee287673ccaa74c24ffd8dcf09ffa555a2fbb59f10ac8
multidict==6.7.1 --hash=sha256:bfde23ef6ed9db7eaee6c37dcec08524cb43903c60b285b172b6c094711b3961
propcache==0.5.2 --hash=sha256:6f328175a2cde1f0ff2c4ed8ce968b9dcfb55f3a7153f39e2957ed994da13476
typing-extensions==4.15.0 --hash=sha256:f0fa19c6845758ab08074a0cfa8b7aecb71c999ca73d62883bc25cc018c4e548
yarl==1.24.2 --hash=sha256:7e7ebcdef69dec6c6451e616f32b622a6d4a2e92b445c992f7c8e5274a6bbc4c
zstandard==0.25.0 --hash=sha256:5a56ba0db2d244117ed744dfa8f6f5b366e14148e00de44723413b2f3938a902
ROOTFS_PIP_REQUIREMENTS

RUN python3 -m venv "$ROOTFS_PIP_HOME" && \
    "$ROOTFS_PIP_HOME/bin/python" -m pip install --disable-pip-version-check --no-cache-dir --only-binary=:all: --require-hashes --no-deps -r /tmp/rootfs-pip-requirements.txt && \
    rm /tmp/rootfs-pip-requirements.txt

# Obtain ubuntu package signing key (to obtain target arch .deb files)
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
# 5. Append the 2012 DSA archive key (used to co-sign older Ubuntu releases like xenial)
#    that was dropped from the modern ubuntu-keyring tarball.
    wget -qO- "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x40976EAF437D05B5" | gpg --dearmor >> /usr/share/keyrings/ubuntu-archive-keyring.gpg && \
    wget -qO- "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x871920D1991BC93C" | gpg --dearmor > /usr/share/keyrings/ubuntu-archive-removed-keys.gpg && \
    popd && \
    rm -r ubuntu-keyring

# Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "f38bd19b7f2d22cafa755841e6ce9375b9a2e6d41f7b974e4953d6b084839001 release-keys.asc" | sha256sum -c && \
    gpg --import release-keys.asc && \
    rm release-keys.asc

RUN \
    # Download llvm sources and signature, and verify signature
    LLVM_VERSION=22.1.7 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "99b4ed667f490ce4bf1006b8fc4e5e2992e7b5e35ce5a4cb52ec47d246bb86d0 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "5cc4a3f12bba50b6bdfb4b61bdc852117a0ff2517807c3902fc13267fb93562e llvm-project.src.tar.xz" | sha256sum -c && \
    gpg --verify llvm-project.src.tar.xz.sig && \
    rm llvm-project.src.tar.xz.sig && \
    # Build LLVM cross-toolchain (with support for targeting x86/x64, arm64, arm, s390x and ppc64le architectures)
    mkdir llvm-project.src && \
    tar -xf llvm-project.src.tar.xz --directory llvm-project.src --strip-components=1 && \
    rm llvm-project.src.tar.xz && \
    mkdir build && \
    pushd build && \
    cmake ../llvm-project.src/llvm \
        -DCMAKE_INSTALL_PREFIX=/opt/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_TARGETS_TO_BUILD="X86;AArch64;ARM;PowerPC;RISCV;SystemZ;LoongArch" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    popd && \
    # Cleanup
    # Don't clean llvm-project.src since it is used by derived images
    rm -rf build

ENV PATH="/opt/llvm/bin:$PATH"

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts
