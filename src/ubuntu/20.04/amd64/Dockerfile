FROM ubuntu.azurecr.io/ubuntu:20.04

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
        pigz \
        sudo \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    # npm installs a vulnerable node-ip pkg. Upgrading the node-ip pkg requires Ubuntu PRO subscription. Workaround by using NPM.
    && npm install -g ip@latest

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
RUN locale-gen en_US.UTF-8

# Install Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-1-install-with-one-command
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Install script does apt-get update and install, so we need to clean up after it.
    && rm -rf /var/lib/apt/lists/*

# Runtime dependencies
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        curl \
        build-essential \
        gettext \
        jq \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Dependencies for VMR/source-build tests
RUN apt-get update \
    && apt-get install -y \
        elfutils \
        file \
    && rm -rf /var/lib/apt/lists/*
