FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-arm32v7

USER root

# Install additional Mono build dependencies
RUN apt-get update \
    && apt-get install -qq -y \
        autoconf \
        libtool \
        automake \
        build-essential \
        gettext \
        wget \
        bc \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and configure it so AzDO knows to use it
RUN apt-get update \
    && apt-get install -qq -y \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/nodejs"

USER helixbot
