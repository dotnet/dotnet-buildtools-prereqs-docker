FROM ubuntu:16.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget && \
    echo "deb https://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" | tee -a /etc/apt/sources.list.d/llvm.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main' && \
    apt-get update && \
    apt-get install -y \
            clang-9 \
            cmake \
            gdb \
            liblldb-6.0-dev \
            lldb-6.0 \
            llvm-9 \
            locales \
            make \
            python-lldb-6.0 \
            sudo && \
    apt-get clean

# Install tools used by the VSO build automation.
RUN apt-get install -y git \
            nodejs \
            npm \
            tar \
            zip && \
    apt-get clean && \
    npm install -g azure-cli@0.9.20 && \
    npm cache clean

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
RUN locale-gen en_US.UTF-8

# Runtime dependencies
RUN apt-get install -y \
            autoconf \
            automake \
            build-essential \
            gettext \
            jq \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libtool \
            libunwind8-dev \
            libunwind8 \
            python3 \
            uuid-dev \
    && apt-get clean
