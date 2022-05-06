FROM mcr.microsoft.com/cbl-mariner/base/core:2.0
RUN tdnf install -y \
        ca-certificates \
        autoconf \
        automake \
        build-essential \
        cmake \
        doxygen \
        gcc \
        gdb \
        git \
        krb5-devel \
        libcurl-devel \
        libedit-devel \
        libicu-devel \
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
	pkgconf \
        readline-devel \
        python3 \
        python3-devel \
	sed \
        sudo \
        swig \
	tar \
        wget \
        which \
        xz \
        zlib-devel

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
    rm compiler-rt-9.0.0.src.tar.xz

RUN ln -s /usr/bin/python3 /usr/bin/python &&\
    mkdir llvmbuild && \
    cd llvmbuild && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_LIBDIR_SUFFIX=64 \
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        -DLLVM_BINUTILS_INCDIR=../binutils-2.29.1/include \
        ../llvm-9.0.0.src
WORKDIR /llvmbuild
#RUN make
#-j $(($(getconf _NPROCESSORS_ONLN)+1))

# RUN make install

#RUN \
    #cd .. && \
    #rm -r llvmbuild && \
    #rm -r llvm-9.0.0.src && \
    #m -r binutils-2.29.1

# Create gcc-9 symlink available in PATH
#RUN ln -s /opt/rh/devtoolset-9/root/usr/bin/gcc /usr/local/bin/gcc-9 && \
#    ln -s /opt/rh/devtoolset-9/root/usr/bin/g++ /usr/local/bin/g++-9

# Create symlink for clang-9's gcc toolchain lookup (used for libgcc, libstdc++ etc.), which does not recognize devtoolset-9
# https://github.com/llvm/llvm-project/blob/release/9.x/clang/lib/Driver/ToolChains/Gnu.cpp#L1906
# (it was later added in clang-10 branch)
#RUN ln -s /opt/rh/devtoolset-9 /opt/rh/devtoolset-8
