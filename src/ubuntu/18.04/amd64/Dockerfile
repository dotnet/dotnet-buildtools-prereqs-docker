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

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g azure-cli@0.10.15 \
    && npm cache clean

# Dependencies for CoreCLR and CoreFX
RUN apt-get update \
    && apt-get install -y \
        gettext \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl1.0-dev \
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
