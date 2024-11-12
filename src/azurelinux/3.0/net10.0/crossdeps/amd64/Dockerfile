FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Provides 'su', required by Azure DevOps
        ca-certificates \
        git \
        pigz \
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
        npm

# Powershell and azure cli aren't currently part of the azure linux 3.0 repositories.
# Install powershell from the rhel8 MS repo, and azure-cli using PIP

# Install powershell from the Microsoft repository. 
RUN curl -sSL -O https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && \
    rpm -i packages-microsoft-prod.rpm && \
    rm -f packages-microsoft-prod.rpm && \
    tdnf update -y && \
    tdnf install -y --setopt tsflags=nodocs \
         powershell && \
    rm /etc/yum.repos.d/microsoft-prod.repo && \
    tdnf clean all

# Install azurecli from PIP
RUN azureEnv="/usr/local/share/azure-cli-env" && \
    python3 -m venv "$azureEnv" && \
    "$azureEnv/bin/python" -m pip install --upgrade setuptools && \
    "$azureEnv/bin/python" -m pip install azure-cli && \
    ln -s "$azureEnv/bin/az" /usr/local/bin/az
