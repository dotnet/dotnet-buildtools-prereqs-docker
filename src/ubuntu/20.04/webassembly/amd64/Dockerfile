FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-coredeps-local

# Dependencies for WebAssembly build
RUN apt-get update \
    && apt-get install -y \
        libssl-dev \
        libtinfo-dev \
        locales \
        nodejs \
        node-gyp \
        npm \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV CMAKE_VERSION=3.17
RUN wget https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz

# WebAssembly build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# WebAssembly build needs typescript
RUN npm i -g typescript

# Install V8 Engine
SHELL ["/bin/bash", "-c"]

ENV V8_VERSION=8.5.183
RUN curl -sSL https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/chromium-v8/v8-linux64-rel-${V8_VERSION}.zip -o ./v8.zip \
    && unzip ./v8.zip -d /usr/local/v8 \
    && echo $'#!/usr/bin/env bash\n\
"/usr/local/v8/d8" --snapshot_blob="/usr/local/v8/snapshot_blob.bin" "$@"\n' > /usr/local/bin/v8 \
    && chmod +x /usr/local/bin/v8

# Install Wasi toolchain
ENV WASI_SDK_VERSION=22
ENV WASI_SDK_PATH=/usr/local/wasi-sdk
ENV WASI_SDK_URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-linux.tar.gz

RUN mkdir -p ${WASI_SDK_PATH} \
    && cd /tmp \
    && curl -L -o /tmp/wasi-sdk.tar.gz ${WASI_SDK_URL} \
    && tar --strip-components=1 -xvzf /tmp/wasi-sdk.tar.gz -C ${WASI_SDK_PATH} \
    && echo ${WASI_SDK_VERSION} > ${WASI_SDK_PATH}/wasi-sdk-version.txt \
    && rm /tmp/wasi-sdk.tar.gz

ENV WASMTIME_VERSION=19.0.2
ENV WASMTIME_PATH=/usr/local/wasmtime
ENV WASMTIME_URL=https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/wasmtime-v${WASMTIME_VERSION}-x86_64-linux.tar.xz

RUN mkdir -p ${WASMTIME_PATH} \
    && cd /tmp \
    && curl -L -o /tmp/wasmtime.tar.xz ${WASMTIME_URL} \
    && tar --strip-components=1 -xvf /tmp/wasmtime.tar.xz -C ${WASMTIME_PATH} \
    && echo ${WASMTIME_VERSION} > ${WASMTIME_PATH}/wasmtime-version.txt \
    && rm /tmp/wasmtime.tar.xz \
    && ln -s ${WASMTIME_PATH}/wasmtime /bin/wasmtime
