FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-coredeps

# Dependencies for WebAssembly build
RUN apt-get update \
    && apt-get install -y \
        locales \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.17.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.17.0-Linux-x86_64.tar.gz

# WebAssembly build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# Install Emscripten toolchain
ENV EMSCRIPTEN_VERSION=1.39.9
RUN git clone https://github.com/emscripten-core/emsdk.git /usr/local/emscripten \
    && cd /usr/local/emscripten \
    && ./emsdk install ${EMSCRIPTEN_VERSION}-upstream \
    && ./emsdk activate --embedded ${EMSCRIPTEN_VERSION}-upstream
