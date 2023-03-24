FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

# TODO: remove this once debootstrap is available in the base repos.
COPY mariner-extended.repo /etc/yum.repos.d/

RUN tdnf update -y && \
    tdnf install -y \
        wget \
        ca-certificates \
        git \
        # Common runtime build dependencies
        cmake \
        awk \
        icu \
        tar \
        # Crosscomponents build dependencies
        glibc-devel \
        lttng-ust-devel \
        kernel-headers

# Obtain arcade scripts used to build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts

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