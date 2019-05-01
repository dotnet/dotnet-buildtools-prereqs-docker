FROM debian:jessie

# Install tools used by the VSO build automation. Set up a new apt-get source to
# get a new version of node and npm: the built-in old cert is no longer valid.
RUN apt-get update \
    && apt-get install -y wget \
    && wget -O - https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install -y \
        git \
        nodejs \
        tar \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    # Set unsafe-perm to true to avoid EACCES.
    && npm install -g azure-cli@0.9.15 --unsafe-perm=true \
    && npm cache clean -f

# Dependencies for generic .NET Core builds
RUN apt-get update \
    && apt-get install -y \
            curl \
            gettext \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libunwind8 \
            libunwind8-dev \
            uuid-dev \
    && rm -rf /var/lib/apt/lists/*
