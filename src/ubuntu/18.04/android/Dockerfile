FROM mcr.microsoft.com/powershell:6.2.1-ubuntu-18.04

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
    && npm cache clean

# Dependencies for CoreCLR, Mono and CoreFX
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gettext \
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
        locales \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Android build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip \
    && unzip android-ndk-r21-linux-x86_64.zip -d /usr/local \
    && mv /usr/local/android-ndk-r21 /usr/local/ndk \
    && rm -f android-ndk-r21-linux-x86_64.zip
