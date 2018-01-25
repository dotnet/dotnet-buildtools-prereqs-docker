FROM debian:8.2

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get update \
    && apt-get install -y \
            git \
            nodejs \
            nodejs-legacy \
            npm \
            tar \
            zip \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g azure-cli@0.10.2 \
    && npm cache clean

# Dependencies for generic .NET Core builds
RUN apt-get update \
    && apt-get install -y \
            curl \
            gettext \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            liblttng-ust-dev \
            libssl-dev \
            libunwind8-dev \
            uuid-dev \
    && rm -rf /var/lib/apt/lists/*
