FROM mcr.microsoft.com/powershell:lts-ubuntu-18.04

# Install tools used by the VSO build automation.
RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        nodejs \
        npm \
        ruby-dev \
        tar \
        zip \
    && gem install fpm \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g azure-cli@0.9.20 \
    && npm cache clean

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
