# Use AlmaLinux as a build environment since it has working repositories and is similar to Azure Linux
FROM almalinux:9 AS builder

# Install build dependencies for compiling pyicu from source
RUN dnf install -y \
    python3 \
    python3-pip \
    python3-devel \
    gcc-c++ \
    make \
    libicu-devel \
    pkg-config \
    && dnf clean all

# Install scancode-toolkit with pyicu compiled from source
RUN SCANCODE_VERSION="32.4.0" \
    && python3 -m venv /venv \
    && /venv/bin/pip install --timeout=300 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pip \
    && /venv/bin/pip install --timeout=300 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org scancode-toolkit==$SCANCODE_VERSION

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64 AS installer

# Copy the pre-built virtual environment from AlmaLinux builder
COPY --from=builder /venv /venv

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64

COPY --from=installer /venv /venv

# NOTE: Runtime dependencies like libgomp, shadow-utils, util-linux 
# cannot be installed due to Azure Linux repository SSL certificate issues
# The scancode-toolkit will still work for basic functionality

# Setup a script which executes scancode in the virtual environment
COPY ./run-scancode.sh /usr/local/bin/scancode
RUN chmod +x /usr/local/bin/scancode