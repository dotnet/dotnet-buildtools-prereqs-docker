FROM mcr.microsoft.com/dotnet/sdk:10.0-azurelinux3.0 AS powershell
ENV POWERSHELL_VERSION=7.6.1
RUN dotnet tool install --tool-path /powershell --version ${POWERSHELL_VERSION} PowerShell

FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

# Install .NET runtime dependencies (inlined from runtime-deps) and build tools
RUN dnf update -y && \
    dnf install -y \
        gawk \
        azure-cli \
        ca-certificates \
        # added to ensure latest patches over the base image
        curl \
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

COPY --from=powershell /usr/share/dotnet/LICENSE.txt /usr/share/dotnet/ThirdPartyNotices.txt /usr/share/dotnet/dotnet /usr/share/dotnet/
COPY --from=powershell /usr/share/dotnet/host /usr/share/dotnet/host
COPY --from=powershell /usr/share/dotnet/shared /usr/share/dotnet/shared
COPY --from=powershell /powershell /usr/share/powershell
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    ln -s /usr/share/powershell/pwsh /usr/bin/pwsh && \
    ln -sf /usr/bin/node-24 /usr/bin/node && \
    ln -sf /usr/bin/npm-24 /usr/bin/npm
