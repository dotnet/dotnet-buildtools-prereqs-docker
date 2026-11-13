ARG BASE_TAG
FROM mcr.microsoft.com/dotnet-buildtools/prereqs:$BASE_TAG

USER root

# Adds compilers, LLVM development files, and build tools on top of the slim Helix image.
# Recommended packages are intentionally installed (e.g. llvm-21-dev and sanitizer runtimes).
RUN apt-get update \
    && apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        clang \
        cmake \
        git \
        libffi-dev \
        libicu-dev \
        libssl-dev \
        libtool \
        libunwind-dev \
        locales-all \
        python3-dev \
        python3-pip \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

USER helixbot
