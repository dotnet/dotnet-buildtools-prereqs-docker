# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM arm64v8/ubuntu:focal

# Install Docker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl https://github.com/PowerShell/PowerShell/releases/download/v7.0.4/powershell-7.0.4-linux-arm64.tar.gz -Lo powershell.tar.gz \
    && echo "0A415C36D53FEFF2324FFCE012F793EEB98F4E6C082C09317096A44E622F13C0  powershell.tar.gz" | sha256sum -c - \
    && mkdir /usr/share/powershell \
    && tar -zxf ./powershell.tar.gz -C /usr/share/powershell \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && rm -f ./powershell-tar.gz
