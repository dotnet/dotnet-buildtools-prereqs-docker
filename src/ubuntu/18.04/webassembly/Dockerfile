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
ENV EMSCRIPTEN_VERSION=2.0.14
ENV EMSDK_PATH=/usr/local/emscripten

RUN git clone https://github.com/emscripten-core/emsdk.git ${EMSDK_PATH} \
    && cd ${EMSDK_PATH} \
    && ./emsdk install ${EMSCRIPTEN_VERSION}-upstream \
    && ./emsdk activate ${EMSCRIPTEN_VERSION}-upstream \
    && chmod -R 777 ${EMSDK_PATH}

# Install V8 Engine to be able to execute Trimming Tests
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt install -y nodejs \
    && npm install jsvu -g \
    && export PATH="${HOME}/.jsvu:${PATH}" \
    && jsvu --os=linux64 --engines=javascriptcore,spidermonkey,v8 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.jsvu:${PATH}"
