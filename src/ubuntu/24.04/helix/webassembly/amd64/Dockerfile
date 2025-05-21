FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-24.04-helix-amd64

USER root

# Dependencies for WebAssembly build
RUN apt-get update \
    && apt-get install -y \
        libasound2t64 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcairo2 \
        libcups2 \
        libdbus-glib-1-2 \
        libdrm2 \
        libgbm-dev \
        libgtk-3-0 \
        libnss3 \
        libpango-1.0-0 \
        libssl-dev \
        libtinfo-dev \
        libxcomposite-dev \
        libxdamage1 \
        libxkbcommon-x11-0 \
        libxrandr2 \
        libx11-xcb-dev \
        locales \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV CMAKE_SHORTVERSION=3.31
ENV CMAKE_VERSION=3.31.7
RUN curl -O https://cmake.org/files/v${CMAKE_SHORTVERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
    && tar -xf cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz

# WebAssembly build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# install node, which is required for newer npm, jsvu and v8
COPY ./setup-node-23.x.sh /tmp
RUN chmod +x /tmp/setup-node-23.x.sh \
    && /tmp/setup-node-23.x.sh \
    && rm /tmp/setup-node-23.x.sh \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm

# Install latest V8 engine
ENV PATH="/home/helixbot/.jsvu/bin:${PATH}"
RUN npm install jsvu -g \
    && su helixbot -c "jsvu --os=linux64 --engines=v8" \
    && v8 -e "console.log(version());quit();" \
    && npm uninstall jsvu -g

USER helixbot
