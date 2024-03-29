FROM ubuntu:18.04

# Install Helix Dependencies

ENV DEBIAN_FRONTEND=noninteractive

# Workaround: https://github.com/pypa/wheel/issues/367
ENV _PYTHON_HOST_PLATFORM=linux_armv7l

# Can remove the mono preview repo when we no longer depend on pre-release libgdiplus

RUN apt-get update && \
    apt-get install -qq -y gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-preview.list && \
    apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        clang \
        cmake \
        curl \
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
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb-3.9 \
        llvm \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        # cryptography wheel requires rust to build on arm32
        rust-all \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Add MsQuic
# MsQuic did not publish arm32 package for 18.04
# Use direct link to signed binary for now
RUN curl -LO https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/libm/libmsquic/libmsquic_2.2.3_armhf.deb && \
    dpkg -i libmsquic_*_armhf.deb && \
    rm -f libmsquic_*_armhf.deb

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==21.3.1 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
    pip install ./helix_scripts-*-py3-none-any.whl

RUN adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot2 && \
    chmod -R +x /root && \
    echo 'helixbot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'helixbot2 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env 
