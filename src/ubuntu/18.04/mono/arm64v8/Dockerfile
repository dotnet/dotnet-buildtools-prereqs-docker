FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-arm64v8

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

USER helixbot
