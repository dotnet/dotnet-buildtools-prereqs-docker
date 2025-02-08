# This should be switched to 10.0 stable and then non-preview
FROM mcr.microsoft.com/dotnet/nightly/runtime-deps:10.0-preview-azurelinux3.0

RUN tdnf install -y \
        awk \
        curl \
        nodejs \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        # Provides 'su', required by Azure DevOps
        tar \
        util-linux \
    && tdnf clean all
