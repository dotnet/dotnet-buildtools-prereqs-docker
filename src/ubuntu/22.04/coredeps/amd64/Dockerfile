FROM mcr.microsoft.com/powershell:ubuntu-22.04

# Install tools used by the AzDO build automation.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

# Runtime dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gettext \
        jq \
        libcurl4-openssl-dev \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        python3 \
        python3-pip \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*
