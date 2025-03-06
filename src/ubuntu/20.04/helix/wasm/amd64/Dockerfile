FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-helix-amd64

ENV DEBIAN_FRONTEND=noninteractive

# Need some additional packages

USER root

RUN apt-get clean && \
    mv /etc/apt/sources.list /etc/apt/sources.list1 && apt-get update && \
    mv /etc/apt/sources.list1 /etc/apt/sources.list && apt-get update && \
    apt-get install -qq -y \
        libnode-dev \
        curl \
        node-gyp \
     && rm -rf /var/lib/apt/lists/* \
     \
     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# update node, which is required for newer npm, jsvu and v8
COPY ./setup-node-23.x.sh /tmp
RUN /tmp/setup-node-23.x.sh && apt-get -y install nodejs

RUN npm install -g npm

USER helixbot

# Install latest V8 engine
ENV PATH="/home/helixbot/.jsvu/bin:${PATH}"
RUN npm install jsvu -g \
    && su helixbot -c "jsvu --os=linux64 --engines=v8" \
    && v8 -e "console.log(version());quit();" \
    && npm uninstall jsvu -g

USER helixbot
