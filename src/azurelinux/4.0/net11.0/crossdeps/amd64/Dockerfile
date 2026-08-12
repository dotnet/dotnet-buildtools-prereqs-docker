FROM mcr.microsoft.com/dotnet/sdk:10.0-azurelinux3.0 AS powershell
ENV POWERSHELL_VERSION=7.6.4
ARG DOTNET_PUBLIC_FEED=https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public/nuget/v3/index.json
RUN dotnet tool install --tool-path /powershell --version ${POWERSHELL_VERSION} PowerShell --source ${DOTNET_PUBLIC_FEED}

FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

RUN dnf update -y && \
    dnf install -y \
        # Provides 'su', required by Azure DevOps
        ca-certificates \
        git \
        shadow-utils \
        util-linux \
        wget2-wget \
        # Common runtime build dependencies
        gawk \
        cpio \
        file \
        gcc \
        gcc-c++ \
        make \
        cmake \
        diffutils \
        gzip \
        icu \
        ninja-build \
        pigz \
        tar \
        # Crosscomponents build dependencies
        glibc-devel \
        kernel-headers \
        lttng-ust-devel \
        # Jit rolling build dependency
        python3-pip \
        # aspnetcore build dependencies
        nodejs24 \
        nodejs24-npm \
        # Provides functionality for AzureCLI AzDO task
        azure-cli \
    && dnf clean all

COPY --from=powershell /usr/share/dotnet/LICENSE.txt /usr/share/dotnet/ThirdPartyNotices.txt /usr/share/dotnet/dotnet /usr/share/dotnet/
COPY --from=powershell /usr/share/dotnet/host /usr/share/dotnet/host
COPY --from=powershell /usr/share/dotnet/shared /usr/share/dotnet/shared
COPY --from=powershell /powershell /usr/share/powershell
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    ln -s /usr/share/powershell/pwsh /usr/bin/pwsh && \
    ln -sf /usr/bin/node-24 /usr/bin/node && \
    ln -sf /usr/bin/npm-24 /usr/bin/npm

# Registry npm installs pull from; defaults to the Microsoft public npm proxy.
# Internal builds override NPM_REGISTRY with the dotnet-public-npm Azure Artifacts feed and set NPM_TOKEN.
ARG NPM_REGISTRY=https://packagefeedproxy.microsoft.io/npm/
ARG NPM_TOKEN

RUN npm config set registry "$NPM_REGISTRY" && \
    if [ -n "$NPM_TOKEN" ]; then \
        npm config set "${NPM_REGISTRY#https:}:_authToken" "$NPM_TOKEN"; \
    fi
