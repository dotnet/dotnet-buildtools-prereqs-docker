FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-azurelinux3.0

RUN tdnf install -y \
        awk \
        nodejs \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        # Provides 'su', required by Azure DevOps
        util-linux \
    && tdnf clean all
