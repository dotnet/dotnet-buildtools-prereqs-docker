# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM debian:stretch

# Install Docker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce=17.12.0~ce-0~debian \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        powershell=6.0.0-1.debian.9 \
    && rm -rf /var/lib/apt/lists/*
