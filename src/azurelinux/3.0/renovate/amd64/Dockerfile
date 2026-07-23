FROM mcr.microsoft.com/azurelinux/base/core:3.0

ARG RENOVATE_VERSION

RUN tdnf update -y && \
    tdnf install -y \
        ca-certificates-microsoft \
        git \
        jq \
        nodejs24 \
        nodejs24-npm \
        powershell \
        \
        # Requirements for Azure DevOps container jobs
        shadow-utils \
        sudo \
        util-linux \
    && tdnf clean all

# Registry npm installs pull from; defaults to the Microsoft public npm proxy.
# Internal builds override NPM_REGISTRY with the dotnet-public-npm Azure Artifacts feed and set NPM_TOKEN.
ARG NPM_REGISTRY=https://packagefeedproxy.microsoft.io/npm/
ARG NPM_TOKEN

RUN npm config set registry "$NPM_REGISTRY" && \
    if [ -n "$NPM_TOKEN" ]; then \
        npm config set "${NPM_REGISTRY#https:}:_authToken" "$NPM_TOKEN"; \
    fi && \
    npm install -g renovate@${RENOVATE_VERSION}
