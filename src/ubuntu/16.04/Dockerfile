FROM ubuntu:16.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update && \
    apt-get install -y wget && \
    echo "deb http://llvm.org/apt/xenial/ llvm-toolchain-xenial main" | tee /etc/apt/sources.list.d/llvm.list && \
    echo "deb http://llvm.org/apt/xenial/ llvm-toolchain-xenial-3.9 main" | tee -a /etc/apt/sources.list.d/llvm.list && \
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y \
            cmake \
            clang-3.9 \
            gdb \
            liblldb-3.9-dev \
            lldb-3.9 \
            llvm-3.9 \
            make \
            python-lldb-3.9 \
            sudo && \
    apt-get clean

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get install -y git \
            zip \
            tar \
            nodejs \
            nodejs-legacy \
            npm && \
    apt-get clean && \
    npm install -g azure-cli@0.9.20 && \
    npm cache clean

# Dependencies for CoreCLR and CoreFX
RUN apt-get install -y gettext \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libunwind8-dev \
            libunwind8 \
            uuid-dev \
    && apt-get clean
