FROM mcr.microsoft.com/cbl-mariner/base/core:2.0
RUN tdnf install -y \
        awk \
        build-essential \
        ca-certificates \
        git \
        icu \
        rpm-build \
        ruby \
        # Provides useradd
        shadow-utils \
        tar \
        # Provides su
        util-linux \
        # Provides sudo
        sudo \
        # Provides functionality for AzureCLI AzDO task
        azure-cli \
        powershell-7.5.5 \
    && tdnf clean all \
    && gem install fpm
