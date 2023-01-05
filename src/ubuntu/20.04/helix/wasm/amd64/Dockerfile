FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-helix-amd64-local

ENV DEBIAN_FRONTEND=noninteractive

# Need some additional packages

USER root

RUN apt-get clean && \
    mv /etc/apt/sources.list /etc/apt/sources.list1 && apt-get update && \
    mv /etc/apt/sources.list1 /etc/apt/sources.list &&  apt-get update && \
    apt-get install -qq -y \
        libnode-dev \
        curl \
        node-gyp \
        npm \
     && rm -rf /var/lib/apt/lists/* \
     \
     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8


USER helixbot

# update node, which is required for newer npm, jsvu and v8
ENV NODE_VERSION 18.12.1
RUN cd ~ && \
    curl -LO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar xf node-v${NODE_VERSION}-linux-x64.tar.xz

USER root

ENV PATH=/home/helixbot/node-v18.12.1-linux-x64/bin:$PATH
RUN npm install -g npm
RUN npm install jsvu -g

USER helixbot

# Install latest V8 engine
RUN jsvu --os=linux64 --engines=v8
ENV PATH="/home/helixbot/.jsvu/bin:${PATH}"
RUN v8 -e "console.log(version());quit();"
