FROM centos:8

# Install dependencies

RUN dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
        epel-release \
    && \
    dnf config-manager --set-enabled powertools \
    && \
    dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        clang \
        cmake \
        curl-devel \
        doxygen \
        findutils \
        gcc \
        gdb \
        git \
        glibc-langpack-en \
        hostname \
        krb5-devel \
        libcurl-devel \
        libedit-devel \
        libicu-devel \
        libidn-devel \
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
