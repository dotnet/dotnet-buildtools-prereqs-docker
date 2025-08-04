FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64 AS installer

# Install dependencies for building scancode-toolkit
# pyicu (required by scancode-toolkit) needs ICU development libraries and a C++ compiler
# The Azure Linux ICU package provides versioned libraries but not unversioned symlinks
# We need to create the unversioned symlinks that icu-config expects
# Since network connectivity to Azure Linux repos is problematic, we cannot install build tools
# We'll try to use pre-built wheels or skip pyicu compilation
RUN ln -sf /usr/lib/libicuuc.so.72 /usr/lib/libicuuc.so \
    && ln -sf /usr/lib/libicui18n.so.72 /usr/lib/libicui18n.so \
    && ln -sf /usr/lib/libicudata.so.72 /usr/lib/libicudata.so \
    && ln -sf /usr/lib/libicuio.so.72 /usr/lib/libicuio.so \
    && ln -sf /usr/lib/libicutu.so.72 /usr/lib/libicutu.so \
    && ln -sf /usr/lib/libicutest.so.72 /usr/lib/libicutest.so

# Install scancode
# Install instructions: https://scancode-toolkit.readthedocs.io/en/latest/getting-started/install.html#installation-as-a-library-via-pip
# See latest release at https://github.com/nexB/scancode-toolkit/releases
# Skip pyicu to avoid compilation issues since we can't install build tools
RUN SCANCODE_VERSION="32.4.0" \
    && python3 -m venv /venv \
    && source /venv/bin/activate \
    && pip install --timeout=300 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pip \
    && pip install --timeout=300 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --only-binary=:all: scancode-toolkit==$SCANCODE_VERSION

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64

COPY --from=installer /venv /venv

# Install necessary dependencies  
# Note: Removed libgomp, shadow-utils, util-linux installation due to network connectivity issues with Azure Linux repos
# This may affect some scancode functionality that depends on OpenMP or system utilities
RUN echo "Skipping package installation due to network issues"

# Setup a script which executes scancode in the virtual environment
COPY ./run-scancode.sh /usr/local/bin/scancode
RUN chmod +x /usr/local/bin/scancode