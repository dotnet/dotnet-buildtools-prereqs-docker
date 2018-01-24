FROM ubuntu:17.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y wget \
    && echo "deb http://llvm.org/apt/zesty/ llvm-toolchain-zesty main" | tee /etc/apt/sources.list.d/llvm.list \
    && echo "deb http://llvm.org/apt/zesty/ llvm-toolchain-zesty-3.9 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        clang-3.9 \
        cmake \
        liblldb-3.9-dev \
        lldb-3.9 \
        llvm-3.9 \
        make \
    && rm -rf /var/lib/apt/lists/*

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        nodejs-legacy \
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
        libcurl4-openssl-dev \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl-dev \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*
