FROM quay.io/centos/centos:stream9

# Install dependencies

RUN dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
    && \
    dnf config-manager --set-enabled crb \
    && \
    dnf module install --setopt tsflags=nodocs -y nodejs:20/common && \
    dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        clang \
        cmake \
        curl-devel \
        doxygen \
        elfutils \
        file \
        findutils \
        gcc \
        gdb \
        git \
        glibc-langpack-en \
        hostname \
        jq \
        krb5-devel \
        libcurl-devel \
        libedit-devel \
        libicu-devel \
        libidn2-devel \
        libnghttp2-devel \
        libtool \
        libuuid-devel \
        libxml2-devel \
        lld \
        lldb-devel \
        llvm \
        lttng-ust-devel \
        lzma \
        make \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        pigz \
        procps-ng \
        python3 \
        python3-devel \
        readline-devel \
        sudo \
        swig \
        tar \
        wget \
        which \
        xz \
        zlib-devel \
    && \
    dnf clean all

# Install powershell and the azure cli from the Microsoft repository
RUN curl -sSL -O https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && \
    rpm -i packages-microsoft-prod.rpm && \
    rm -f packages-microsoft-prod.rpm && \
    dnf update -y && \
    dnf install -y --setopt tsflags=nodocs \
        azure-cli \
        powershell && \
    dnf clean all

ENV \
    NO_UPDATE_NOTIFIER=true \
    # Sha1 is disabled by default centos:stream9 but sevaral CI jobs still rely on it.
    OPENSSL_ENABLE_SHA1_SIGNATURES=1
