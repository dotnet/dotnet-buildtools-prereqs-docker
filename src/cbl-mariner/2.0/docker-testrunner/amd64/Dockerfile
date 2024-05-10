# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf install -y \
        ca-certificates \
        # Install Docker
        moby-engine \
        moby-buildx \
        moby-cli \
        # Test dependencies
        git \
        powershell \
    && tdnf clean all
