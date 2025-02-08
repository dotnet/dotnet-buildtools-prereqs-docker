FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-azurelinux3.0

RUN tdnf install -y \
        awk \
        # added to ensure latest patches over the base image
        curl \
        nodejs \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        # Provides 'su', required by Azure DevOps
        util-linux \
    && tdnf clean all
