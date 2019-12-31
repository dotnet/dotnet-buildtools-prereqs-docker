FROM mcr.microsoft.com/powershell:6.2.1-ubuntu-16.04

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        nodejs-legacy \
        npm \
        tar \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN apt-get update \
    && apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install azure-cli \
    && rm -rf /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && rm -rf /etc/apt/sources.list.d/azure-cli.list \
    && rm -rf /var/lib/apt/lists/*

# Dependencies for CoreCLR and CoreFX
RUN apt-get update \
    && apt-get install -y \
        gettext \
        libcurl4-openssl-dev \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl-dev \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*
