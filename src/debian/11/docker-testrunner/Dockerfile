# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM debian:bullseye-slim

# Install Docker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
# Use the Bash shell instead of the default shell because we need to use Bash-specific features for parsing the powerShellVersionTag variable 
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
        libicu67 \
    && rm -rf /var/lib/apt/lists/* \
    && arch=$(dpkg --print-architecture) \
    && if [ "$arch" = "amd64" ]; then arch="x64"; fi \
    && powerShellVersionTag=$(curl --silent https://api.github.com/repos/PowerShell/PowerShell/releases/latest | jq -r .tag_name) \
    && curl https://github.com/PowerShell/PowerShell/releases/download/$powerShellVersionTag/powershell-${powerShellVersionTag:1}-linux-$arch.tar.gz -Lo powershell.tar.gz
RUN \
    mkdir /usr/share/powershell \
    && tar -zxf ./powershell.tar.gz -C /usr/share/powershell \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && rm -f ./powershell-tar.gz

# Use the default shell again
SHELL ["/bin/sh", "-c"]
