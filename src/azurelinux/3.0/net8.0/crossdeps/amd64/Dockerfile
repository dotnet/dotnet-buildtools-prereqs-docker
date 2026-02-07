FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        ca-certificates \
        curl \
        git \
        shadow-utils \
        # Provides 'su', required by Azure DevOps
        util-linux \
        unzip \
        wget \
        zip \
        # Common runtime build dependencies
        awk \
        binutils \
        gcc \
        make \
        cmake \
        pkg-config \
        diffutils \
        icu \
        tar \
        zlib-devel \
        # Crosscomponents build dependencies
        glibc-devel \
        glibc-static \
        kernel-headers \
        lttng-ust-devel \
        # vcpkg/openssl build dependencies
        perl \
        perl-IPC-Cmd \
        # Jit rolling build dependency
        python3-pip \
        # aspnetcore build dependencies
        nodejs \
        npm \
        # Provides functionality for AzureCLI AzDO task
        azure-cli \
        powershell
