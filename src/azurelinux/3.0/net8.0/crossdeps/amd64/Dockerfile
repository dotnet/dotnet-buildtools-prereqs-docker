FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        ca-certificates \
        git \
        shadow-utils \
        # Provides 'su', required by Azure DevOps
        util-linux \
        wget \
        # Common runtime build dependencies
        awk \
        gcc \
        make \
        cmake \
        diffutils \
        icu \
        tar \
        zlib-devel \
        # Crosscomponents build dependencies
        glibc-devel \
        kernel-headers \
        lttng-ust-devel \
        # Jit rolling build dependency
        python3-pip \
        # aspnetcore build dependencies
        nodejs \
        npm \
        # Provides functionality for AzureCLI AzDO task
        azure-cli \
        powershell
