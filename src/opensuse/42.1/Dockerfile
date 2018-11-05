FROM opensuse:42.1

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN zypper -n install \
        cmake \
        gcc-c++ \
        gdb \
        hostname \
        lldb-devel \
        llvm-clang \
        llvm-devel \
        python \
        python-xml \
        wget \
        which \
    && ln -s /usr/bin/clang++ /usr/bin/clang++-3.5 \
    && zypper clean -a

# Install tools used by the VSO build automation.
RUN zypper -n install \
        git \
        npm \
        nodejs \
        tar \
        zip \
    && zypper clean -a \
    && npm install -g azure-cli --unsafe-perm=true \
    && npm cache clean -f

# Build and install liblldb development files
RUN zypper -n install \
    doxygen \
    libedit-devel \
    libxml2-devel \
    python-argparse \
    python-devel \
    readline-devel \
    swig && \
    \
    wget http://cmake.org/files/v3.11/cmake-3.11.4-Linux-x86_64.tar.gz && \
    wget http://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/lldb-3.9.1.src.tar.xz && \
    \
    tar -xf cmake-3.11.4-Linux-x86_64.tar.gz && \
    tar -xf llvm-3.9.1.src.tar.xz && \
    mkdir llvm-3.9.1.src/tools/clang && \
    mkdir llvm-3.9.1.src/tools/lldb && \
    tar -xf cfe-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/clang && \
    tar -xf lldb-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/lldb && \
    rm cmake-3.11.4-Linux-x86_64.tar.gz && \
    rm cfe-3.9.1.src.tar.xz && \
    rm lldb-3.9.1.src.tar.xz && \
    rm llvm-3.9.1.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    ../cmake-3.11.4-Linux-x86_64/bin/cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLDB_DISABLE_CURSES=1 \
        -DLLVM_LIBDIR_SUFFIX=64 \
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        -DLLVM_BUILD_DOCS=0 \
        ../llvm-3.9.1.src \
    && \
    make -j $(($(getconf _NPROCESSORS_ONLN)+1)) && \
    make install && \
    cd .. && \
    rm -r llvmbuild && \
    rm -r llvm-3.9.1.src && \
    rm -r cmake-3.11.4-Linux-x86_64 && \
    \
    zypper -n rm \
    doxygen \
    libedit-devel \
    libxml2-devel \
    ncurses-devel \
    python-argparse \
    python-devel \
    readline-devel \
    swig && \
    \
    zypper clean -a

# Dependencies of CoreCLR and CoreFX.
RUN zypper -n install --force-resolution \
        glibc-locale \
        krb5-devel \
        libcurl-devel \
        libgdiplus0 \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        libopenssl-devel \
        uuid-devel \
    && zypper clean -a
