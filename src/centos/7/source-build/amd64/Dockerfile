FROM centos:7

# Install dependencies

RUN yum install -y \
        centos-release-scl \
        epel-release \
        scl-utils-build \
    && \
    yum install -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        devtoolset-9-gcc* \
        doxygen \
        gdb \
        git \
        jq \
        krb5-devel \
        libcurl-devel \
        libedit-devel \
        libgdiplus \
        libicu-devel \
        libidn-devel \
        libmetalink-devel \
        libnghttp2-devel \
        libssh2-devel \
        libstdc++-static \
        libtool \
        libunwind-devel \
        libuuid-devel \
        libxml2-devel \
        llvm-toolset-7.0 \
        llvm-toolset-7.0-cmake \
        lttng-ust-devel \
        lzma \
        make \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        python-argparse \
        python-devel \
        readline-devel \
        python3 \
        sudo \
        swig \
        wget \
        which \
        xz \
        zlib-devel \
    && \
    yum clean all

ENTRYPOINT [ "scl", "enable", "llvm-toolset-7.0", "--" ]

CMD [ "/bin/bash" ]
