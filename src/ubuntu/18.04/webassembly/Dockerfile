FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-coredeps

# Dependencies for WebAssembly build
RUN apt-get update \
    && apt-get install -y \
        libssl1.0-dev \
        libdbus-glib-1-2 \
        locales \
        nodejs-dev \
        node-gyp \
        npm \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.17.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.17.0-Linux-x86_64.tar.gz

# WebAssembly build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# WebAssembly build needs typescript
RUN npm i -g typescript

# Install Emscripten toolchain
ENV EMSCRIPTEN_VERSION=3.1.9
ENV EMSCRIPTEN_PATH=/usr/local/emscripten
ENV EMSDK_PATH=/usr/local/emscripten/emsdk

RUN mkdir ${EMSCRIPTEN_PATH} \
    && cd ${EMSCRIPTEN_PATH} \
    && git clone https://github.com/emscripten-core/emsdk.git ${EMSDK_PATH} \
    && cd ${EMSDK_PATH} \
    && ./emsdk install ${EMSCRIPTEN_VERSION}-upstream \
    && ./emsdk activate ${EMSCRIPTEN_VERSION}-upstream \
    && chmod -R 777 ${EMSCRIPTEN_PATH}

# Install V8 Engine
SHELL ["/bin/bash", "-c"]

RUN curl -sSL "https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/chromium-v8/v8-linux64-rel-8.5.183.zip" -o ./v8.zip \
    && unzip ./v8.zip -d /usr/local/v8 \
    && echo $'#!/usr/bin/env bash\n\
"/usr/local/v8/d8" --snapshot_blob="/usr/local/v8/snapshot_blob.bin" "$@"\n' > /usr/local/bin/v8 \
    && chmod +x /usr/local/bin/v8
