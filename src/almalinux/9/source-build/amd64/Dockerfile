FROM library/almalinux:9

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        'dnf-command(config-manager)' \
        epel-release \
    && dnf config-manager --set-enabled crb \
    && dnf config-manager --set-enabled epel \
    && dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        brotli-devel \
        cmake \
        cpio \
        elfutils \
        file \
        gdb \
        git \
        glibc-langpack-en \
        iproute \
        jq \
        krb5-devel \
        libcurl-devel \
        libicu-devel \
        libtool \
        # Requires epel
        libunwind-devel \
        libuuid-devel \
        libxml2-devel \
        llvm-toolset \
        lld \
        # Requires powertools
        lttng-ust-devel \
        make \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        readline-devel \
        python3.12 \
        sudo \
        swig \
        wget \
        which \
        xz \
        zlib-devel \
    && dnf module install -y \
        nodejs:22 \
    && dnf clean all
