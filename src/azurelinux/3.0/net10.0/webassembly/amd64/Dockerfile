FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-cross-amd64

# Dependencies for WebAssembly build
RUN tdnf update -y \
    && tdnf install -y \
        # WebAssembly build dependencies
        which \
        nodejs \
        npm \
        pigz \
        python3 \
        libxml2 \
        unzip

# WebAssembly build needs typescript
RUN npm i -g typescript

# Install V8 Engine
SHELL ["/bin/bash", "-c"]

ENV V8_VERSION=10.8.168
RUN curl -sSL https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/chromium-v8/v8-linux64-rel-${V8_VERSION}.zip -o ./v8.zip \
    && unzip ./v8.zip -d /usr/local/v8 \
    && echo $'#!/usr/bin/env bash\n\
"/usr/local/v8/d8" --snapshot_blob="/usr/local/v8/snapshot_blob.bin" "$@"\n' > /usr/local/bin/v8 \
    && chmod +x /usr/local/bin/v8

# Install Wasi toolchain
ENV WASI_SDK_MAJOR_VERSION=25
ENV WASI_SDK_VERSION=${WASI_SDK_MAJOR_VERSION}.0
ENV WASI_SDK_PATH=/usr/local/wasi-sdk
ENV WASI_SDK_URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_MAJOR_VERSION}/wasi-sdk-${WASI_SDK_VERSION}-x86_64-linux.tar.gz

RUN mkdir -p ${WASI_SDK_PATH} \
    && cd /tmp \
    && curl -L -o /tmp/wasi-sdk.tar.gz ${WASI_SDK_URL} \
    && tar --strip-components=1 -xvzf /tmp/wasi-sdk.tar.gz -C ${WASI_SDK_PATH} \
    && echo ${WASI_SDK_VERSION} > ${WASI_SDK_PATH}/wasi-sdk-version.txt \
    && echo ${WASI_SDK_VERSION} > ${WASI_SDK_PATH}/WASI-SDK-VERSION-${WASI_SDK_VERSION} \
    && rm /tmp/wasi-sdk.tar.gz

ENV WASMTIME_VERSION=27.0.0
ENV WASMTIME_PATH=/usr/local/wasmtime
ENV WASMTIME_URL=https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/wasmtime-v${WASMTIME_VERSION}-x86_64-linux.tar.xz

RUN mkdir -p ${WASMTIME_PATH} \
    && cd /tmp \
    && curl -L -o /tmp/wasmtime.tar.xz ${WASMTIME_URL} \
    && tar --strip-components=1 -xvf /tmp/wasmtime.tar.xz -C ${WASMTIME_PATH} \
    && echo ${WASMTIME_VERSION} > ${WASMTIME_PATH}/wasmtime-version.txt \
    && rm /tmp/wasmtime.tar.xz \
    && ln -s ${WASMTIME_PATH}/wasmtime /bin/wasmtime
