FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64 AS installer

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
RUN SCANCODE_VERSION="32.4.1" \
    && python3 -m venv /venv \
    && source /venv/bin/activate \
    && pip install scancode-toolkit==$SCANCODE_VERSION \
    && pip install click==8.2.2


FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64

COPY --from=installer /venv /venv

# Install necessary dependencies
RUN tdnf update -y \
    && tdnf install -y \
        libgomp \
        shadow-utils \
        util-linux \
    && tdnf clean all

# Setup a script which executes scancode in the virtual environment
COPY ./run-scancode.sh /usr/local/bin/scancode
RUN chmod +x /usr/local/bin/scancode
