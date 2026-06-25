FROM mcr.microsoft.com/powershell:ubuntu-22.04

# Use the approved Azure-hosted Ubuntu mirror (per Network Isolation team guidance).
RUN find /etc/apt -type f \( -name '*.sources' -o -name '*.list' \) -exec sed -i 's|//archive\.ubuntu\.com|//azure.archive.ubuntu.com|g' {} +

# Install tools used by the AzDO build automation.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git \
        tar \
        zip \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

# Runtime dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gettext \
        jq \
        libcurl4-openssl-dev \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        python3 \
        python3-pip \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*

# Token used to authenticate to the dotnet-public-npm Azure Artifacts feed.
ARG NPM_TOKEN

# Install Node 20 from NodeSource and use the patched npm ip module.
# When NPM_TOKEN is provided (internal builds) use the dotnet-public-npm Azure Artifacts feed;
# otherwise fall back to the default public registry (public builds have no token).
RUN cd /etc/apt/sources.list.d && \
    rm -f nodesource.list && \
    cd ~ && \
    curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f nodesource_setup.sh && \
    if [ -n "$NPM_TOKEN" ]; then \
        npm config set registry https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/ && \
        npm config set "//pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/:_authToken" "$NPM_TOKEN"; \
    fi && \
    npm install -g ip@latest
