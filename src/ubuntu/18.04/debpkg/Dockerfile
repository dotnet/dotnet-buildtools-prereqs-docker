FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04

# Install the deb packaging toolchain we need to build debs
RUN apt-get update \
    && apt-get -y install \
        build-essential \
        debhelper \
        devscripts \
        liblldb-3.9 \
    && rm -rf /var/lib/apt/lists/*
