FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf update -y && \
    tdnf install -y \
        ca-certificates \
        git \
        # Provides 'su', required by Azure DevOps
        util-linux \
        wget \
        # Common runtime build dependencies
        awk \
        cmake \
        diffutils \
        icu \
        tar \
        zlib-devel \
        # Crosscomponents build dependencies
        glibc-devel \
        kernel-headers \
        lttng-ust-devel \
        # Jit rolling build dependency
        python3-pip \
        # diagnostics build dependency
        lldb-devel \
        # Provides functionality for AzureCLI AzDO task
        azure-cli \
        powershell

# Validate checksums with keyring after https://github.com/microsoft/azurelinux/issues/3142 is resolved
ENV NODE_VERSION=22.16.0
RUN mkdir /usr/share/node && \
    curl -O https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt && \
    curl -O -sSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    grep node-v${NODE_VERSION}-linux-x64.tar.xz SHASUMS256.txt | sha256sum -c - && \
    tar xf node-v${NODE_VERSION}-linux-x64.tar.xz -J -C /usr/share/node --strip-components=1 && \
    ln -s /usr/share/node/bin/node /usr/local/bin/node && \
    ln -s /usr/share/node/bin/npm /usr/local/bin/npm && \
    ln -s /usr/share/node/bin/npx /usr/local/bin/npx && \
    rm SHASUMS256.txt && \
    rm node-v${NODE_VERSION}-linux-x64.tar.xz
