FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN dnf update -y && \
    dnf install -y \
        # Common utilities
        ca-certificates \
        git \
        gnupg2 \
        jq \
        gzip \
        shadow-utils \
        tar \
        unzip \
        wget2-wget \
        xz \
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
        zlib-ng-compat-devel \
        # Rootfs build dependencies
        bzip2-devel \
        libarchive-devel \
        openssl-devel \
        python3 \
    && dnf clean all

ENV ROOTFS_PIP_HOME=/usr/local/share/rootfs

COPY <<ROOTFS_PIP_REQUIREMENTS /tmp/rootfs-pip-requirements.txt
aiohappyeyeballs==2.6.2 --hash=sha256:4708045e2d7a6c6bdf8aafa8ed39649eaf926a4543b54560659129e3365953c4
aiohttp==3.13.5 --hash=sha256:241a94f7de7c0c3b616627aaad530fe2cb620084a8b144d3be7b6ecfe95bae3b
aiosignal==1.4.0 --hash=sha256:053243f8b92b990551949e63930a839ff0cf0b0ebbe0597b0f3fb19e1a0fe82e
attrs==26.1.0 --hash=sha256:c647aa4a12dfbad9333ca4e71fe62ddc36f4e63b2d260a37a8b83d2f043ac309
frozenlist==1.8.0 --hash=sha256:cba69cb73723c3f329622e34bdbf5ce1f80c21c290ff04256cff1cd3c2036ed2
idna==3.15 --hash=sha256:048adeaf8c2d788c40fee287673ccaa74c24ffd8dcf09ffa555a2fbb59f10ac8
multidict==6.7.1 --hash=sha256:7eee46ccb30ff48a1e35bb818cc90846c6be2b68240e42a78599166722cea709
propcache==0.5.2 --hash=sha256:e00820e192c8dbebcafb383ebbf99030895f09905e7a0eb2e0340a0bcc2bc825
typing-extensions==4.15.0 --hash=sha256:f0fa19c6845758ab08074a0cfa8b7aecb71c999ca73d62883bc25cc018c4e548
yarl==1.24.2 --hash=sha256:e51b2cf5ec89a8b8470177641ed62a3ba22d74e1e898e06ad53aa77972487208
zstandard==0.25.0 --hash=sha256:e09bb6252b6476d8d56100e8147b803befa9a12cea144bbe629dd508800d1ad0
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
    wget https://netcorenativeassets.blob.core.windows.net/resource-packages/external/ubuntu/ubuntu-keyring/ubuntu-keyring_2023.11.28.1.tar.xz && \
    echo "aecd455ae15561371d6e454f121f079f0641d5e1b579a5563a2bc363fc74aa2e ubuntu-keyring_2023.11.28.1.tar.xz" | sha256sum -c && \
    tar xf ubuntu-keyring_2023.11.28.1.tar.xz && \
    rm ubuntu-keyring_2023.11.28.1.tar.xz && \
# 3. Verify keyrings
    pushd ubuntu-keyring && \
    gpg --output SHA512SUMS.txt --decrypt SHA512SUMS.txt.asc && \
    sha512sum -c SHA512SUMS.txt && \
# 4. Install the needed keyrings and delete the rest
    mkdir -p /usr/share/keyrings && \
    cp keyrings/ubuntu-archive-keyring.gpg /usr/share/keyrings/ubuntu-archive-keyring.gpg && \
    cp keyrings/ubuntu-archive-removed-keys.gpg /usr/share/keyrings/ubuntu-archive-removed-keys.gpg && \
# 5. Include removed archive keys for older Ubuntu release signatures (for example, xenial).
    cat /usr/share/keyrings/ubuntu-archive-removed-keys.gpg >> /usr/share/keyrings/ubuntu-archive-keyring.gpg && \
    popd && \
    rm -r ubuntu-keyring

# Obtain Debian keyrings
# 1. Download the debian keyrings
RUN wget https://netcorenativeassets.blob.core.windows.net/resource-packages/external/debian/debian-archive-keyring_2025.1.tar.xz && \
    echo "7fe6a901070d2fb24f897cfe768060d4a51341f936c83e6bdb0fd0282774de4a debian-archive-keyring_2025.1.tar.xz" | sha256sum -c && \
    tar xf debian-archive-keyring_2025.1.tar.xz && \
    rm debian-archive-keyring_2025.1.tar.xz && \
# 2. Install the needed keyrings and delete the rest
    pushd debian-keyring && \
    mkdir -p /usr/share/keyrings && \
    cp keyrings/debian-archive-keyring.gpg /usr/share/keyrings/debian-archive-keyring.gpg && \
    cp keyrings/debian-archive-removed-keys.gpg /usr/share/keyrings/debian-archive-removed-keys.gpg && \
# 3. Include removed archive keys for older Debian release signatures
    cat /usr/share/keyrings/debian-archive-removed-keys.gpg >> /usr/share/keyrings/debian-archive-keyring.gpg && \
    popd && \
    rm -r debian-keyring

# Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "f38bd19b7f2d22cafa755841e6ce9375b9a2e6d41f7b974e4953d6b084839001 release-keys.asc" | sha256sum -c && \
    gpg --import release-keys.asc && \
    rm release-keys.asc

RUN \
    # Download llvm sources and signature, and verify signature
    LLVM_VERSION=22.1.8 && \
    wget -O llvm-project.src.tar.xz.sig https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz.sig && \
    echo "052eeebd58a2df67db066c6defb3ae67572bdf098d3064b8ed111b5385d45910 llvm-project.src.tar.xz.sig" | sha256sum -c && \
    wget -O llvm-project.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz && \
    echo "922f1817a0df7b1489272d18134ee0087a8b068828f87ac63b9861b1a9965888 llvm-project.src.tar.xz" | sha256sum -c && \
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
ARG ARCADE_COMMIT=e5f974ba880c3da69932191c665e90ee64e8da26
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git init /scripts && \
    git -C /scripts fetch --depth 1 https://github.com/dotnet/arcade ${ARCADE_COMMIT} && \
    git -C /scripts checkout --detach FETCH_HEAD

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
