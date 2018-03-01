FROM i386/ubuntu:16.04

# Setup the home directory
RUN mkdir -p /home/dotnet-bot

# Set up the dotnet-bot user
RUN groupadd dotnet-bot && useradd -d /home/dotnet-bot -g dotnet-bot -M -s /bin/bash dotnet-bot

# Set up permissions
RUN chown -R dotnet-bot:dotnet-bot /home/dotnet-bot

# Setup mount point for coreclr
RUN mkdir -p /home/dotnet-bot/coreclr

# Include all of the usual coreclr dependencies
RUN apt-get update && \
    apt-get install -y \
        cmake \
        llvm-3.9 \
        clang-3.9 \
        lldb-3.9 \
        liblldb-3.9-dev \
        libunwind8 \
        libunwind8-dev \
        gettext \
        libicu-dev \
        liblttng-ust-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        uuid-dev \
        libnuma-dev \
        libkrb5-dev \
        binfmt-support \
    && apt-get clean


USER dotnet-bot

WORKDIR /home/dotnet-bot
CMD bash