FROM arm64v8/ubuntu:22.04

# Install Helix Dependencies
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        clang \
        gcc \
        gdb \
        git \
        gss-ntlmssp \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        libnuma-dev \
        liblttng-ust-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb-12 \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
        unzip \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==22.0.4 && \
    python -m pip install virtualenv==20.14.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
    pip install ./helix_scripts-*-py3-none-any.whl

# build MsQuic as we don't have packages
RUN cd /tmp && \
    mkdir pwsh && \
    cd pwsh && \
    curl -LO https://github.com/PowerShell/PowerShell/releases/download/v7.2.5/powershell-7.2.5-linux-arm64.tar.gz && \
    echo "709265A0B99232CD8AB6F8A02C01F3AEE94262B959E1A4B0FD871C8789C07396 powershell-7.2.5-linux-arm64.tar.gz" | sha256sum --check - && \
    tar xf powershell-7.2.5-linux-arm64.tar.gz && \
    cd .. && \
    git clone --depth 1 --single-branch --branch release/7.0 --recursive https://github.com/dotnet/msquic && \
    cd msquic/src/msquic  &&  PATH=~/.dotnet/tools:$PATH /tmp/pwsh/pwsh scripts/build.ps1 -arch arm64 -Config Release -DisableTools -DisableTest -DisablePerf && \
    cp artifacts/bin/linux/arm64_Release_openssl/libmsquic.so.2 artifacts/bin/linux/arm64_Release_openssl/libmsquic.lttng.so.2.1.0 /usr/lib/aarch64-linux-gnu && \
    cd /tmp && \
    rm -r pwsh msquic

RUN adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    chmod -R +x /root && \
    echo 'helixbot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER helixbot

RUN python -m virtualenv /home/helixbot/.vsts-env
