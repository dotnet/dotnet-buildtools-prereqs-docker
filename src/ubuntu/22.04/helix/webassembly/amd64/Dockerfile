FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-helix-amd64

USER root

# Dependencies for WebAssembly build
RUN apt-get update \
    && apt-get install -y \
        libasound2 \
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
        wget \
    && rm -rf /var/lib/apt/lists/*

ENV CMAKE_VERSION=3.17
RUN wget https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-${CMAKE_VERSION}.0-Linux-x86_64.tar.gz

# WebAssembly build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# install node, which is required for newer npm, jsvu and v8
COPY ./setup-node-23.x.sh /tmp
RUN /tmp/setup-node-23.x.sh && apt-get -y install nodejs

RUN npm install -g npm

# Install latest V8 engine
ENV PATH="/home/helixbot/.jsvu/bin:${PATH}"
RUN npm install jsvu -g \
    && su helixbot -c "jsvu --os=linux64 --engines=v8" \
    && v8 -e "console.log(version());quit();" \
    && npm uninstall jsvu -g

USER helixbot
