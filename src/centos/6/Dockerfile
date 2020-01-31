FROM centos:6

# Install dependencies

RUN yum install -y \
        centos-release-SCL \
        epel-release \
        scl-utils-build \
        wget \
    && \
    rpm --import http://linuxsoft.cern.ch/cern/slc6X/x86_64/RPM-GPG-KEY-cern && \
    wget -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo && \
    yum install -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        byacc \
        devtoolset-7-gcc* \
        doxygen \
        expat-devel \
        gdb \
        gettext-devel \
        git \
        krb5-devel \
        libedit-devel \
        libidn-devel \
        libmetalink-devel \
        libnghttp2-devel \
        libssh2-devel \
        libtool \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        lzma \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        pcre-devel \
        perl-devel \
        python-argparse \
        python27 \
        readline-devel \
        python34 \
        sudo \
        xz \
        zlib-devel \
    && \
    yum clean all

# Install CMake 3.15.5

RUN wget -O cmake-install.sh https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.sh && \
    bash ./cmake-install.sh --skip-license --exclude-subdir --prefix=/usr/local && \
    rm ./cmake-install.sh

# Build and install swig (newer version needed for lldb build)
RUN git clone https://github.com/swig/swig.git && \
    cd swig && \
    git checkout rel-4.0.1 && \
    scl enable python27 devtoolset-7 \
    ' \
        ./autogen.sh &&\
        ./configure && \
        make  -j $(($(getconf _NPROCESSORS_ONLN)+1)) && \
        make install \
    ' && \
    cd .. && \
    rm -r swig

# Build and install clang and lldb 9

RUN wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.29.1.tar.xz && \
    wget http://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/lldb-9.0.0.src.tar.xz && \
    wget http://releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz && \
    \
    tar -xf binutils-2.29.1.tar.xz && \
    tar -xf llvm-9.0.0.src.tar.xz && \
    mkdir llvm-9.0.0.src/tools/clang && \
    mkdir llvm-9.0.0.src/tools/lldb && \
    mkdir llvm-9.0.0.src/projects/compiler-rt && \
    tar -xf cfe-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/tools/clang && \
    tar -xf lldb-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/tools/lldb && \
    tar -xf compiler-rt-9.0.0.src.tar.xz --strip 1 -C llvm-9.0.0.src/projects/compiler-rt && \
    rm binutils-2.29.1.tar.xz && \
    rm cfe-9.0.0.src.tar.xz && \
    rm lldb-9.0.0.src.tar.xz && \
    rm llvm-9.0.0.src.tar.xz && \
    rm compiler-rt-9.0.0.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    scl enable python27 devtoolset-7 \
    ' \
        cmake \
            -DCMAKE_CXX_COMPILER=/opt/rh/devtoolset-7/root/usr/bin/g++ \
            -DCMAKE_C_COMPILER=/opt/rh/devtoolset-7/root/usr/bin/gcc \
            -DCMAKE_LINKER=/opt/rh/devtoolset-7/root/usr/bin/ld \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_LIBDIR_SUFFIX=64 \
            -DLLVM_ENABLE_EH=1 \
            -DLLVM_ENABLE_RTTI=1 \
            -DLLVM_BINUTILS_INCDIR=../binutils-2.29.1/include \
            ../llvm-9.0.0.src \
        && \
        make -j $(($(getconf _NPROCESSORS_ONLN)+1)) && \
        make install \
    ' && \
    cd .. && \
    rm -r llvmbuild && \
    rm -r llvm-9.0.0.src && \
    rm -r binutils-2.29.1

# Build and install curl 7.45.0

RUN wget https://curl.haxx.se/download/curl-7.45.0.tar.lzma && \
    tar -xf curl-7.45.0.tar.lzma && \
    rm curl-7.45.0.tar.lzma && \
    cd curl-7.45.0 && \
    scl enable python27 devtoolset-7 \
    ' \
        ./configure \
            --disable-dict \
            --disable-ftp \
            --disable-gopher \
            --disable-imap \
            --disable-ldap \
            --disable-ldaps \
            --disable-libcurl-option \
            --disable-manual \
            --disable-pop3 \
            --disable-rtsp \
            --disable-smb \
            --disable-smtp \
            --disable-telnet \
            --disable-tftp \
            --enable-ipv6 \
            --enable-optimize \
            --enable-symbol-hiding \
            --with-ca-bundle=/etc/pki/tls/certs/ca-bundle.crt \
            --with-nghttp2 \
            --with-gssapi \
            --with-ssl \
            --without-librtmp \
        && \
        make install \
    ' && \
    cd .. && \
    rm -r curl-7.45.0

# Install ICU 57.1

RUN wget http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-RHEL6-x64.tgz && \
    tar -xf icu4c-57_1-RHEL6-x64.tgz -C / && \
    rm icu4c-57_1-RHEL6-x64.tgz

# Compile and install a version of the git that supports the features that cli repo build needs
# NOTE: The git needs to be built after the curl so that it can use the libcurl to add https
# protocol support.
RUN \
    wget https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz && \
    tar -xf git-2.9.5.tar.gz && \
    rm git-2.9.5.tar.gz && \
    cd  git-2.9.5 && \
    scl enable python27 devtoolset-7 \
    ' \
        make configure && \
        ./configure --prefix=/usr/local --without-tcltk && \
        make -j $(nproc --all) all && \
        make install \
    ' && \
    cd .. && \
    rm -r git-2.9.5

ENV LD_LIBRARY_PATH=/usr/local/lib
