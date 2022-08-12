FROM ubuntu:20.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y \
        cmake \
        clang-12 \
        gdb \
        liblldb-12-dev \
        lldb-12 \
        llvm-12 \
        locales \
        make \
        sudo \
        wget

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
        curl \
    && rm -rf /var/lib/apt/lists/*

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
RUN locale-gen en_US.UTF-8

# Install Azure CLI
RUN curl -L -o azure-cli_focal_all.deb https://aka.ms/InstallAzureCliFocalEdge \
    && dpkg -i azure-cli_focal_all.deb

# Runtime dependencies
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        curl \
        build-essential \
        gettext \
        jq \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*
