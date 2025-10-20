FROM quay.io/centos/centos:stream9

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf module install --setopt tsflags=nodocs -y \
        nodejs:20/common \
    && dnf install --setopt tsflags=nodocs -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        clang \
        cmake \
        curl-devel \
        doxygen \
        elfutils \
        file \
        findutils \
        gcc \
        gdb \
        git \
        glibc-langpack-en \
        hostname \
        jq \
        krb5-devel \
        libcurl-devel \
        libedit-devel \
        libicu-devel \
        libidn2-devel \
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
        openssl-devel \
        perl-FindBin \
        procps-ng \
        python3 \
        python3-devel \
        python3-pip \
        readline-devel \
        sudo \
        swig \
        tar \
        wget \
        which \
        xz \
        zlib-devel \
    && dnf clean all

# Install openmp from llvm 3.9.1.
RUN wget http://releases.llvm.org/3.9.1/openmp-3.9.1.src.tar.xz \
    && mkdir -p llvm-3.9.1.src/openmp \
    && tar -xf openmp-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/openmp \
    && rm -f openmp-3.9.1.src.tar.xz \
    \
    && mkdir llvmbuild \
    && cd llvmbuild \
    && cmake \
        -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
        -DCMAKE_C_COMPILER=/usr/bin/clang \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_LIBDIR_SUFFIX=64\
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        ../llvm-3.9.1.src/openmp \
     \
     && make -j $(($(getconf _NPROCESSORS_ONLN)+1)) \
     && make install \
     && cd .. \
     && rm -f -r llvmbuild \
     && rm -f -r llvm-3.9.1.src

# Sets the library path to pickup openmp
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

RUN ln -sf /usr/bin/python3 /usr/bin/python

ENV LANG=en_US.utf8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot
WORKDIR /home/helixbot
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

RUN python -m venv $VIRTUAL_ENV && \
    ${VIRTUAL_ENV}/bin/pip install --upgrade pip setuptools && \
    ${VIRTUAL_ENV}/bin/pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    ${VIRTUAL_ENV}/bin/pip install ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
