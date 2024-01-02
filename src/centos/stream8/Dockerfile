FROM quay.io/centos/centos:stream8

# Install dependencies

RUN dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
    && \
    dnf config-manager --set-enabled powertools \
    && \
    dnf module install --setopt tsflags=nodocs -y nodejs:20/common && \
    dnf install -y epel-release && \
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
        # new dependency required when linking against libc++ instead of libstdc++ \
        libatomic \
        libcurl-devel \
        libedit-devel \
        libicu-devel \
        libidn2-devel \
        libnghttp2-devel \
        libtool \
        libuuid-devel \
        libunwind \
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
