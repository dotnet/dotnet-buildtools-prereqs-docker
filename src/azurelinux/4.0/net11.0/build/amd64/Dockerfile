FROM mcr.microsoft.com/dotnet/sdk:10.0-azurelinux3.0 AS sdk
FROM mcr.microsoft.com/dotnet/runtime:10.0-azurelinux3.0 AS runtime

FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

# Install .NET runtime dependencies (inlined from runtime-deps) and build tools
RUN dnf install -y \
        azure-cli \
        ca-certificates \
        # added to ensure latest patches over the base image
        curl \
        gawk \
        git \
        icu \
        nodejs24 \
        nodejs24-npm \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        # Provides 'su', required by Azure DevOps
        util-linux \
    && dnf clean all

# Copy .NET runtime and PowerShell from Azure Linux 3.0 images
COPY --from=runtime /usr/share/dotnet /usr/share/dotnet
COPY --from=sdk /usr/share/powershell /usr/share/powershell
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    ln -s /usr/share/powershell/pwsh /usr/bin/pwsh && \
    ln -s /usr/bin/node-24 /usr/bin/node && \
    ln -s /usr/bin/npm-24 /usr/bin/npm
