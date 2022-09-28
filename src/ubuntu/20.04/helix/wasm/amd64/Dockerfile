FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-helix-amd64-local

ENV DEBIAN_FRONTEND=noninteractive

# Need some additional packages

USER root

RUN apt-get clean && \
    mv /etc/apt/sources.list /etc/apt/sources.list1 && apt-get update && \
    mv /etc/apt/sources.list1 /etc/apt/sources.list &&  apt-get update && \
    apt-get install -qq -y \
        libnode-dev \
        node-gyp \
        npm \
     && rm -rf /var/lib/apt/lists/* \
     \
     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8


RUN npm install jsvu -g

USER helixbot

# Install V8 & other engines in the non-root context
RUN jsvu --os=linux64 --engines=v8
ENV PATH="/home/helixbot/.jsvu:${PATH}"
RUN v8 -e "console.log(version());quit();"
