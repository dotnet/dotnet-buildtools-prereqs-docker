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

# npm registry. Defaults to the public dotnet-public-npm Azure Artifacts feed, which is
# readable anonymously (works for local/dev and public builds). NPM_TOKEN is optional and
# only needed by internal builds that ingest new package versions into the feed.
ARG NPM_REGISTRY=https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/
ARG NPM_TOKEN

RUN npm config set registry "$NPM_REGISTRY" && \
    if [ -n "$NPM_TOKEN" ]; then \
        npm config set "${NPM_REGISTRY#https:}:_authToken" "$NPM_TOKEN"; \
    fi && \
    npm install -g renovate@${RENOVATE_VERSION}
