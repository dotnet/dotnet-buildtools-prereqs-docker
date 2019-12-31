FROM ubuntu:16.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget && \
    echo "deb http://llvm.org/apt/xenial/ llvm-toolchain-xenial-9 main" | tee -a /etc/apt/sources.list.d/llvm.list && \
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main' && \
    apt-get update && \
    apt-get install -y \
            clang-9 \
            cmake \
            gdb \
            liblldb-6.0-dev \
            lldb-6.0 \
            llvm-9 \
            make \
            python-lldb-6.0 \
            sudo && \
    apt-get clean

# Install tools used by the VSO build automation.  nodejs-legacy is a Debian specific
# package that provides `node' on the path (which azure cli needs).
RUN apt-get install -y git \
            nodejs \
            nodejs-legacy \
            npm \
            tar \
            zip && \
    apt-get clean

# Dependencies for CoreCLR and CoreFX
RUN apt-get install -y gettext \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libunwind8-dev \
            libunwind8 \
            uuid-dev \
    && apt-get clean

# Install Azure CLI
RUN apt-get update \
    && apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install azure-cli \
    && rm -rf /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && rm -rf /etc/apt/sources.list.d/azure-cli.list \
    && rm -rf /var/lib/apt/lists/*
