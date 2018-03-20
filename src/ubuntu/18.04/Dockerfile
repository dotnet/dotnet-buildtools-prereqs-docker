FROM ubuntu:18.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y \
        clang-3.9 \
        liblldb-3.9-dev \
        lldb-3.9 \
        llvm-3.9 \
        make \
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
        libcurl-openssl1.0-dev \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl1.0-dev \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*

