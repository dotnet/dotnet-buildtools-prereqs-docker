FROM mcr.microsoft.com/azurelinux/base/core:3.0

ARG RENOVATE_VERSION

RUN tdnf install -y \
        ca-certificates \
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

RUN npm install -g renovate@${RENOVATE_VERSION}
