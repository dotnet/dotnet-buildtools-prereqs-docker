FROM arm32v7/debian:9

# Dependencies for generic .NET Core builds
RUN apt-get update \
    && apt-get install -y \
            autoconf \
            automake \
            build-essential \
            curl \
            gettext \
            jq \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblttng-ust-dev \
            libssl-dev \
            libtool \
            libunwind8 \
            libunwind8-dev \
            uuid-dev \
    && rm -rf /var/lib/apt/lists/*
