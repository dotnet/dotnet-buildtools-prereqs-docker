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

RUN dnf update -y && \
    dnf install -y \
        # Provides 'su', required by Azure DevOps
        ca-certificates \
        curl \
        git \
        shadow-utils \
        util-linux \
        pam \
        sudo \
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

# GNU toolchain is installed in 'x86_64-azurelinux-linux' directory which is not recognized by
# clang (https://github.com/llvm/llvm-project/blob/main/clang/lib/Driver/ToolChains/Gnu.cpp),
# so we create a symlink with -pc- triplet.
RUN ln -s /usr/lib/gcc/$(uname -m)-azurelinux-linux /usr/lib/gcc/$(uname -m)-pc-linux-gnu && \
    ln -s /usr/include/c++/15/$(uname -m)-azurelinux-linux /usr/include/c++/15/$(uname -m)-pc-linux-gnu;

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
