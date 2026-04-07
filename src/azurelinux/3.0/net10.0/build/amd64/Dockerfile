FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-azurelinux3.0

RUN tdnf install -y \
        awk \
        azure-cli \
        ca-certificates-microsoft \
        # added to ensure latest patches over the base image
        curl \
        git \
        nodejs24 \
        nodejs24-npm \
        powershell \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        # Provides 'su', required by Azure DevOps
        util-linux \
    && tdnf clean all
