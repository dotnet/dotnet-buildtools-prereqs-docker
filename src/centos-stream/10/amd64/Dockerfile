FROM quay.io/centos/centos:stream10

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    # rhel/10 packages don't exist yet, so we use the rhel/9 packages
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/9/prod/config.repo \
    && dnf config-manager --set-enabled crb \
    && dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
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
        numactl-devel \
        openssl \
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
