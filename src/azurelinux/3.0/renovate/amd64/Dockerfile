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

# Token used to authenticate to the dotnet-public-npm Azure Artifacts feed.
ARG NPM_TOKEN

# When NPM_TOKEN is provided (internal builds) use the dotnet-public-npm Azure Artifacts feed;
# otherwise fall back to the default public registry (public builds have no token).
RUN if [ -n "$NPM_TOKEN" ]; then \
        npm config set registry https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/ && \
        npm config set "//pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/:_authToken" "$NPM_TOKEN"; \
    fi && \
    npm install -g renovate@${RENOVATE_VERSION}
