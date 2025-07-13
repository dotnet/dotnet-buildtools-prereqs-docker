# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf install -y \
        ca-certificates \
        # Install Docker
        moby-engine \
        docker-buildx \
        docker-cli \
        # Test dependencies
        azure-cli \
        git \
        powershell \
        shadow-utils \
    && tdnf clean all
