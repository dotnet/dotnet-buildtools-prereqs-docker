FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

# Azure Linux 4.0 has no 'powershell' package (#1646), so PowerShell is installed from the
# upstream self-contained tarball, the same way the ubuntu, alpine and debian images do it.
# It has to stay self-contained: a framework-dependent pwsh resolves its runtime from the
# ambient 'dotnet', and arcade prepends the repo-local SDK to PATH for every step after the
# build, so pwsh would then fail to start with a major-version mismatch
# ("You must install or update .NET to run this application").
ENV POWERSHELL_VERSION=7.6.6
# SHA256 of powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz
ENV POWERSHELL_SHA256=ddbc4a2d113bbd46d283cfedcbcd117a70caefd7673f41f2b4e0000badf103bc

# SHA-1 signatures are disabled by default in Azure Linux 4.0, but strong-name signing needs them.
ENV OPENSSL_ENABLE_SHA1_SIGNATURES=1

# Install .NET runtime dependencies (inlined from runtime-deps) and build tools
RUN dnf update -y && \
    dnf install -y \
        gawk \
        azure-cli \
        ca-certificates \
        # added to ensure latest patches over the base image
        curl \
        git \
        gzip \
        icu \
        nodejs24 \
        nodejs24-npm \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        # Provides 'su', required by Azure DevOps
        util-linux \
        pam \
        sudo \
    && dnf clean all

# Install PowerShell
RUN curl -L "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz" -o /tmp/powershell.tar.gz \
    && echo "${POWERSHELL_SHA256}  /tmp/powershell.tar.gz" | sha256sum -c - \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz

RUN ln -sf /usr/bin/node-24 /usr/bin/node && \
    ln -sf /usr/bin/npm-24 /usr/bin/npm

# Registry npm installs pull from; defaults to the Microsoft public npm proxy.
# Internal builds override NPM_REGISTRY with the dotnet-public-npm Azure Artifacts feed and set NPM_TOKEN.
ARG NPM_REGISTRY=https://packagefeedproxy.microsoft.io/npm/
ARG NPM_TOKEN

RUN npm config set registry "$NPM_REGISTRY" && \
    if [ -n "$NPM_TOKEN" ]; then \
        npm config set "${NPM_REGISTRY#https:}:_authToken" "$NPM_TOKEN"; \
    fi
