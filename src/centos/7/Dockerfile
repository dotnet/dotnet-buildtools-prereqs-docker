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
        ca-certificates \
        devtoolset-7-gcc* \
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
        libtool \
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
        python3 \
        sudo \
        swig \
        wget \
        which \
        xz \
        zlib-devel \
    && \
    yum clean all

# Install CMake 3.15.5

RUN wget -O cmake-install.sh https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.sh && \
    bash ./cmake-install.sh --skip-license --exclude-subdir --prefix=/usr/local && \
    rm ./cmake-install.sh

# Build and install clang and lldb 9.0.0

RUN wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.29.1.tar.xz && \
    wget http://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/lld-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/lldb-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz && \
    \
    tar -xf binutils-2.29.1.tar.xz && \
    tar -xf llvm-9.0.0.src.tar.xz && \
    mkdir llvm-9.0.0.src/tools/clang && \
    mkdir llvm-9.0.0.src/tools/lld && \
    mkdir llvm-9.0.0.src/tools/lldb && \
    mkdir llvm-9.0.0.src/projects/compiler-rt && \
    tar -xf cfe-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/tools/clang && \
    tar -xf lld-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/tools/lld && \
    tar -xf lldb-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/tools/lldb && \
    tar -xf compiler-rt-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/projects/compiler-rt && \
    rm binutils-2.29.1.tar.xz && \
    rm cfe-9.0.0.src.tar.xz && \
    rm lld-9.0.0.src.tar.xz && \
    rm lldb-9.0.0.src.tar.xz && \
    rm llvm-9.0.0.src.tar.xz && \
    rm compiler-rt-9.0.0.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    scl enable devtoolset-9 'cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_LIBDIR_SUFFIX=64\
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        -DLLVM_BINUTILS_INCDIR=../binutils-2.29.1/include \
        ../llvm-9.0.0.src' \
    && \
    scl enable devtoolset-9 'make -j $(($(getconf _NPROCESSORS_ONLN)+1))' && \
    make install && \
    cd .. && \
    rm -r llvmbuild && \
    rm -r llvm-9.0.0.src && \
    rm -r binutils-2.29.1

# Create gcc-7 symlink available in PATH
RUN ln -s /opt/rh/devtoolset-7/root/usr/bin/gcc /usr/local/bin/gcc-7 && \
    ln -s /opt/rh/devtoolset-7/root/usr/bin/g++ /usr/local/bin/g++-7

# Create gcc-9 symlink available in PATH
RUN ln -s /opt/rh/devtoolset-9/root/usr/bin/gcc /usr/local/bin/gcc-9 && \
    ln -s /opt/rh/devtoolset-9/root/usr/bin/g++ /usr/local/bin/g++-9

# Create symlink for clang-9's gcc toolchain lookup (used for libgcc, libstdc++ etc.), which does not recognize devtoolset-9
# https://github.com/llvm/llvm-project/blob/release/9.x/clang/lib/Driver/ToolChains/Gnu.cpp#L1906
# (it was later added in clang-10 branch)
RUN ln -s /opt/rh/devtoolset-9 /opt/rh/devtoolset-8
