FROM quay.io/centos/centos:stream9

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/9/prod/config.repo \
    && dnf config-manager --set-enabled crb \
    && dnf module install --setopt tsflags=nodocs -y \
        nodejs:20/common \
    && dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        azure-cli \
        brotli-devel \
        clang \
        cmake \
        cpio \
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
        iproute \
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
        openssl-devel \
        pigz \
        powershell \
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
    && dnf clean all

ENV \
    NO_UPDATE_NOTIFIER=true \
    # Sha1 is disabled by default centos:stream9 but sevaral CI jobs still rely on it.
    OPENSSL_ENABLE_SHA1_SIGNATURES=1
