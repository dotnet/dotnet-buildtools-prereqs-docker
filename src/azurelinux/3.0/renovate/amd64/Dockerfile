FROM mcr.microsoft.com/azurelinux/base/core:3.0

ARG RENOVATE_VERSION

RUN tdnf install -y \
        ca-certificates \
        git \
        nodejs24 \
        nodejs24-npm \
        \
        # Requirements for Azure DevOps container jobs
        shadow-utils \
        sudo \
        util-linux \
    && tdnf clean all

RUN npm install -g renovate@${RENOVATE_VERSION}
