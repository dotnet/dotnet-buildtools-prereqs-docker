FROM centos:7

# Install dependencies

RUN yum install -y \
        centos-release-SCL \
        epel-release \
    && \
    yum install -y \
        "perl(Time::HiRes)" \
        cmake \
        cmake3 \
        doxygen \
        gcc \
        gcc-c++ \
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
        libunwind-devel \
        libuuid-devel \
        libxml2-devel \
        lttng-ust-devel \
        lzma \
        make \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        python-argparse \
        python27 \
        python-devel \
        readline-devel \
        sudo \
        swig \
        wget \
        which \
        xz \
        zlib-devel \
    && \
    yum clean all

# Build and install clang and lldb 3.9.1

RUN wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.29.1.tar.xz && \
    wget http://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/lldb-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/compiler-rt-3.9.1.src.tar.xz && \
    \
    tar -xf binutils-2.29.1.tar.xz && \
    tar -xf llvm-3.9.1.src.tar.xz && \
    mkdir llvm-3.9.1.src/tools/clang && \
    mkdir llvm-3.9.1.src/tools/lldb && \
    mkdir llvm-3.9.1.src/projects/compiler-rt && \
    tar -xf cfe-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/clang && \
    tar -xf lldb-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/lldb && \
    tar -xf compiler-rt-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/projects/compiler-rt && \
    rm binutils-2.29.1.tar.xz && \
    rm cfe-3.9.1.src.tar.xz && \
    rm lldb-3.9.1.src.tar.xz && \
    rm llvm-3.9.1.src.tar.xz && \
    rm compiler-rt-3.9.1.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    cmake3 \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_LIBDIR_SUFFIX=64\
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        -DLLVM_BINUTILS_INCDIR=../binutils-2.29.1/include \
        ../llvm-3.9.1.src \
    && \
    make -j $(($(getconf _NPROCESSORS_ONLN)+1)) && \
    make install && \
    cd .. && \
    rm -r llvmbuild && \
    rm -r llvm-3.9.1.src && \
    rm -r binutils-2.29.1