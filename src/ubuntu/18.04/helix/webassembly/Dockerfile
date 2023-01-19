FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-amd64-local

# Need some additional packages

USER root

RUN apt-get update \
    && apt-get install -y \
        curl \
        libdbus-glib-1-2 \
        libgtk-3-0 \
        libasound2 \
        libx11-xcb-dev \
        npm \
    && rm -rf /var/lib/apt/lists/*

USER helixbot

# update node, which is required for newer npm, jsvu and v8
ENV NODE_VERSION 16.19.0
RUN cd ~ && \
    curl -LO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar xf node-v${NODE_VERSION}-linux-x64.tar.xz

USER root

ENV PATH=/home/helixbot/node-v${NODE_VERSION}-linux-x64/bin:$PATH
RUN npm install -g npm
RUN npm install jsvu -g

USER helixbot

# Install latest V8 engine
RUN jsvu --os=linux64 --engines=v8
ENV PATH="/home/helixbot/.jsvu/bin:${PATH}"
RUN v8 -e "console.log(version());quit();"
