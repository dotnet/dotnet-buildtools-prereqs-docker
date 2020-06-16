# Dockerfile used to create a testrunner image that can perform Docker operations.
# Usage:  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -File xyz.ps1

FROM arm64v8/debian:stretch-slim

# Install Docker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        libicu57 \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce=17.12.0~ce-0~debian \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl https://github.com/PowerShell/PowerShell/releases/download/v7.0.2/powershell-7.0.2-linux-arm64.tar.gz -Lo powershell.tar.gz \
    && echo "8677301996B5335B872D267D41F588C145EEFFA6B9736962530480B4D15CC295  powershell.tar.gz" | sha256sum -c - \
    && mkdir /usr/share/powershell \
    && tar -zxf ./powershell.tar.gz -C /usr/share/powershell \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && rm -f ./powershell-tar.gz
