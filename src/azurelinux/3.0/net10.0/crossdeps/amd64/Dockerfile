FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Provides 'su', required by Azure DevOps
        ca-certificates \
        git \
        pigz \
        shadow-utils \
        util-linux \
        wget \
        # Common runtime build dependencies
        awk \
        cpio \
        file \
        gcc \
        make \
        cmake \
        diffutils \
        icu \
        tar \
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
