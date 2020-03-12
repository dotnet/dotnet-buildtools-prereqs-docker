FROM ubuntu:18.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y \
        clang-3.9 \
        gdb \
        liblldb-3.9-dev \
        lldb-3.9 \
        llvm-3.9 \
        make \
        python-lldb-3.9 \
        sudo \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.10.2-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.10.2-Linux-x86_64.tar.gz

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install -y \
        azure-cli \
    && rm -rf /var/lib/apt/lists/*

# Dependencies for CoreCLR, Mono and CoreFX
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gettext \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl1.0-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*

# Build and install curl 7.45.0
RUN wget https://curl.haxx.se/download/curl-7.45.0.tar.lzma \
    && tar -xf curl-7.45.0.tar.lzma \
    && rm curl-7.45.0.tar.lzma \
    && cd curl-7.45.0 \
    && ./configure \
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
        --with-ca-path=/etc/ssl/certs/ \
        --with-nghttp2 \
        --with-gssapi \
        --with-ssl \
        --without-librtmp \
    && make install \
    && cd .. \
    && rm -r curl-7.45.0
