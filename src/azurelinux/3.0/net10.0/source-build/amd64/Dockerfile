FROM mcr.microsoft.com/azurelinux/base/core:3.0 AS installer

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

ENV SCANCODE_VERSION=32.5.0

# Install dependencies for building pyicu wheel from source (dependency of scancode-toolkit)
RUN tdnf update -y \
    && tdnf install -y \
        binutils \
        gcc-c++ \
        glibc-devel \
        icu-devel \
        kernel-headers \
        python3-devel \
    && tdnf clean all

# Include scancode
# Install instructions: https://scancode-toolkit.readthedocs.io/en/latest/getting-started/install.html#installation-as-a-library-via-pip
# See latest release at https://github.com/nexB/scancode-toolkit/releases
RUN python3 -m venv /venv \
    && source /venv/bin/activate \
    && pip install scancode-toolkit==$SCANCODE_VERSION


FROM mcr.microsoft.com/azurelinux/base/core:3.0

COPY --from=installer /venv /venv

# Install .NET runtime dependencies (inlined from runtime-deps) and scancode runtime dependencies.
# The .NET SDK itself is installed by the VMR (eng/common/dotnet.sh) at the version pinned in global.json.
RUN tdnf update -y \
    && tdnf install -y \
        ca-certificates \
        curl \
        git \
        gzip \
        icu \
        krb5 \
        libgcc \
        libgomp \
        libstdc++ \
        openssl-libs \
        python3 \
        # provides 'useradd', required by Azure DevOps
        shadow-utils \
        tar \
        tzdata \
        # provides 'su', required by Azure DevOps
        util-linux \
        zlib \
    && tdnf clean all

# Setup a script which executes scancode in the virtual environment
COPY <<SCANCODE /usr/local/bin/scancode
#!/bin/bash
set -euo pipefail
source /venv/bin/activate
scancode "\$@"
SCANCODE

RUN chmod +x /usr/local/bin/scancode

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
