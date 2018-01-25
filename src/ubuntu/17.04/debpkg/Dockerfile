FROM microsoft/dotnet-buildtools-prereqs:ubuntu-17.04

# Install the deb packaging toolchain we need to build debs
RUN apt-get update \
    && apt-get -y install \
        debhelper \
        build-essential \
        devscripts \
    && rm -rf /var/lib/apt/lists/*

# liblldb is needed so deb package build does not throw missing library info errors
# Package resource list is already set in the base Image /etc/apt/sources.list.d/llvm.list
RUN apt-get update \
    && apt-get -y install liblldb-3.9 \
    && rm -rf /var/lib/apt/lists/*
