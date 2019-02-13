FROM arm64v8/ubuntu:18.04

RUN apt-get update && \
    dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y \
        libstdc++6:armhf \
        libunwind8:armhf \
        libunwind8-dev:armhf \
        libicu-dev:armhf \
        liblttng-ust-dev:armhf \
        libcurl4-openssl-dev:armhf \
        libicu-dev:armhf \
        libssl-dev \
        libkrb5-dev:armhf \
    && rm -rf /var/lib/apt/lists/*
