ARG DOTNET_SDK_TAG
FROM mcr.microsoft.com/dotnet/sdk:$DOTNET_SDK_TAG

# Use the approved Azure-hosted Ubuntu mirror (per Network Isolation team guidance).
RUN find /etc/apt -type f \( -name '*.sources' -o -name '*.list' \) -exec sed -i 's|//archive\.ubuntu\.com|//azure.archive.ubuntu.com|g' {} +

# Dependencies for running VS Code integration tests.
RUN apt-get update \
    && apt-get install -y \
        libasound2t64 \
        libgtk-3-0 \
        libnss3 \
        xvfb \
    && rm -rf /var/lib/apt/lists/*
