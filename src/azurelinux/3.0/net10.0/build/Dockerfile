# This should be switched to 10.0 stable and then non-preview
FROM mcr.microsoft.com/dotnet/nightly/runtime-deps:10.0-preview-azurelinux3.0

RUN tdnf install -y \
        azure-cli \
        awk \
        # added to ensure latest patches over the base image
        curl \
        git \
        nodejs \
        pwsh \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        # Provides 'su', required by Azure DevOps
        util-linux \
    && tdnf clean all
