FROM mcr.microsoft.com/powershell:7.1.0-ubuntu-20.04

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        git \
        nodejs \
        npm \
        tar \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g azure-cli@0.9.20 \
    && npm cache clean --force

# Runtime dependencies
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gettext \
        jq \
        libcurl4-openssl-dev \
        libgdiplus \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        python3 \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*
