FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-azurelinux3.0-amd64

# Install scancode
# Install instructions: https://scancode-toolkit.readthedocs.io/en/latest/getting-started/install.html#installation-as-a-library-via-pip
# See latest release at https://github.com/nexB/scancode-toolkit/releases
ENV venv="/tmp/scancode-env"
RUN SCANCODE_VERSION="32.3.3" && \
    #!/bin/bash
    set -euo pipefail && \
    python3 -m venv $venv && \
    source $venv/bin/activate && \
    pip install scancode-toolkit==$SCANCODE_VERSION && \
    deactivate

# Setup a script which executes scancode in the virtual environment
RUN cat > /usr/local/bin/scancode <<EOF
#!/bin/bash
set -euo pipefail
source $venv/bin/activate
scancode "\$@"
deactivate
EOF
RUN chmod +x /usr/local/bin/scancode

# Install necessary dependencies
RUN tdnf update -y && \
    tdnf install -y \
        libgomp \
    && tdnf clean all