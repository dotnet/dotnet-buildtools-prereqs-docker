FROM ubuntu.azurecr.io/ubuntu:22.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y \
        cmake \
        clang-14 \
        gdb \
        liblldb-14-dev \
        lldb-14 \
        llvm-14 \
        locales \
        make \
        pigz \
        sudo \
        && rm -rf /var/lib/apt/lists/*

# This link fixes the broken lldb python scripting that the diagnostics tests require
RUN mkdir -p /usr/lib/local/lib/python3.10/dist-packages/lldb \
    && ln -s /usr/lib/llvm-14/lib/python3.10/dist-packages/lldb/* /usr/lib/local/lib/python3.10/dist-packages/lldb

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        git \
        npm \
        zip \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    # npm installs a vulnerable node-ip pkg. Upgrading the node-ip pkg requires Ubuntu PRO subscription. Workaround by using NPM.
    && npm install -g ip@latest

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
RUN locale-gen en_US.UTF-8

# Install Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions
# We cannot use the helper script to install the CLI with one command as the script
# gets an amd64-only DEB package while this image needs to support both amd64 and arm64.
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \ 
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install -y azure-cli \
    && rm -rf /var/lib/apt/lists/*

# Runtime dependencies
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        cpio \
        curl \
        build-essential \
        gettext \
        jq \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
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

# Remove older version of node & install node 20
RUN cd /etc/apt/sources.list.d  && \
    rm -f nodesource.list && \
    apt --fix-broken install && \
    apt update && \
    apt-get remove nodejs -y && \
    apt-get remove nodejs-doc -y && \
    apt-get remove libnode-dev -y

RUN cd ~ && \
    curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f nodesource_setup.sh

ENV NO_UPDATE_NOTIFIER=true
