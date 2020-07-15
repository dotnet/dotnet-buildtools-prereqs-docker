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
        clang \
        devtoolset-7-gcc* \
        doxygen \
        gdb \
        git \
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
        llvm \
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

# Add cmake 3.6.2. This is not including in the package manager, yum install 
# cmake will include 2.8

RUN wget https://github.com/Kitware/CMake/releases/download/v3.6.2/cmake-3.6.2-Linux-x86_64.tar.gz && \
    tar -xvf cmake-3.6.2-Linux-x86_64.tar.gz && \
    mv cmake-3.6.2-Linux-x86_64 /cmake

# Add to path
ENV PATH "${PATH}:/cmake/bin"