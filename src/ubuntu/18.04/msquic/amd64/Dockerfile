FROM mcr.microsoft.com/powershell:lts-ubuntu-18.04

# Install pwsh and the base toolchain we need to build anything (clang, cmake, make and the like)
# this is similar to prepare-machine.ps1  -Configuration Build
RUN curl -OL https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        dotnet-sdk-5.0 \
        git \
        liblttng-ust-dev \
        libssl-dev \
        lttng-tools \
        rpm \
        ruby ruby-dev \
        sudo \
    && rm -rf /var/lib/apt/lists/* \
    && gem install fpm \
    && curl -OL https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.17.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.17.0-Linux-x86_64.tar.gz

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
RUN locale-gen en_US.UTF-8

