FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04

# Install the deb packaging toolchain we need to build debs
RUN apt-get update \
    && apt-get -y install \
        build-essential \
        debhelper \
        devscripts \
        liblldb-14 \
    && rm -rf /var/lib/apt/lists/*

# Install powershell. This is in the debpkg/amd64 docker file as it may not be required in the arm64
# images, and is not actually supported over there.
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    software-properties-common \
    curl && \
    curl -sL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/*
