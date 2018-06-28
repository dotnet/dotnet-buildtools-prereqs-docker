FROM fedora:24

# Workaround to avoid NuGet restore timeout
RUN dnf upgrade -y nss \
    && dnf clean all

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y \
        clang \
        cmake \
        findutils \
        gdb \
        llvm-devel \
        make \
        python \
        which \
    && dnf clean all

# Install tools used by the VSO build automation.
RUN dnf install -y \
        git \
        npm \
        nodejs \
        tar \
        zip \
    && dnf clean all \
    && npm install -g azure-cli \
    && npm cache clean

# Build and install liblldb development files
RUN dnf -y install \
    doxygen \
    libedit-devel \
    libxml2-devel \
    python-argparse \
    python-devel \
    readline-devel \
    swig \
    wget \
    xz && \
    \
    wget http://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz && \
    wget http://releases.llvm.org/3.9.1/lldb-3.9.1.src.tar.xz && \
    \
    tar -xf llvm-3.9.1.src.tar.xz && \
    mkdir llvm-3.9.1.src/tools/clang && \
    mkdir llvm-3.9.1.src/tools/lldb && \
    tar -xf cfe-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/clang && \
    tar -xf lldb-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/tools/lldb && \
    rm cfe-3.9.1.src.tar.xz && \
    rm lldb-3.9.1.src.tar.xz && \
    rm llvm-3.9.1.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    cmake \
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
    \
    dnf -y remove \
    doxygen \
    libedit-devel \
    libxml2-devel \
    readline-devel \
    swig && \
    \
    dnf clean all

# Dependencies of CoreCLR and CoreFX.
RUN dnf install -y \
        glibc-locale-source \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
        uuid-devel \
    && dnf clean all
