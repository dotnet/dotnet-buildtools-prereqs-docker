FROM arm32v7/ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        libstdc++6 \
        libunwind8 \
        libunwind8-dev \
        libicu-dev \
        libnuma-dev \
        liblttng-ust-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libssl-dev \
        libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*
