FROM arm64v8/debian:buster

# Install Helix Dependencies

RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        at \
        build-essential \
        curl \
        gcc \
        gdb \
        git \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        liblttng-ust-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        locales \
        locales-all \
        procps \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O https://cmake.org/files/v3.23/cmake-3.23.1-linux-aarch64.tar.gz \
    && echo "74062efddeb935bce3d33694a4db534cef9a650f77a9a153a9f217d9dc385c75 cmake-3.23.1-linux-aarch64.tar.gz" | sha256sum --check - \
    && tar -xf cmake-3.23.1-linux-aarch64.tar.gz  --strip 1 -C /usr/local \
    && rm cmake-3.23.1-linux-aarch64.tar.gz \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
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
    cd msquic/src/msquic  &&  PATH=~/.dotnet/tools:$PATH /tmp/pwsh/pwsh scripts/build.ps1 -arch arm64 -Config Release && \
    cp artifacts/bin/linux/arm64_Release_openssl/libmsquic.so.2 artifacts/bin/linux/arm64_Release_openssl/libmsquic.lttng.so.2.1.0 /usr/lib/aarch64-linux-gnu && \
    cd /tmp && \
    rm -r pwsh msquic powershell-7.2.5-linux-arm64.tar.gz

# Create helixbot user and give rights to sudo without password
# additionally, preinstall the virtualenv packages used for VSTS reporting to save time
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
