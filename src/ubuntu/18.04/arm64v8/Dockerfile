FROM arm64v8/ubuntu:18.04

# fpm install may fail without adding public_suffix explicitly. May be remove in the future.
# https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/675
RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        libstdc++6 \
        libunwind8 \
        libunwind8-dev \
        libicu-dev \
        libnuma-dev \
        liblttng-ust-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libssl-dev \
        libtool \
        libkrb5-dev \
        ruby-dev \
    && gem install public_suffix -v 4.0.7 \
    && gem install fpm \
    && rm -rf /var/lib/apt/lists/*
