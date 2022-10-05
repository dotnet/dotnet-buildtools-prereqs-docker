FROM ubuntu:18.04

# Install Helix Dependencies

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
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
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb-3.9 \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
        unzip \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O https://cmake.org/files/v3.23/cmake-3.23.1-linux-aarch64.tar.gz \
    && echo "74062efddeb935bce3d33694a4db534cef9a650f77a9a153a9f217d9dc385c75 cmake-3.23.1-linux-aarch64.tar.gz" | sha256sum --check - \
    && tar -xf cmake-3.23.1-linux-aarch64.tar.gz  --strip 1 -C /usr/local \
    && rm cmake-3.23.1-linux-aarch64.tar.gz \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
    pip install ./helix_scripts-*-py3-none-any.whl

# Add MsQuic
# MsQuic did not publish arm64 package for 18.04
# Use direct link to signed binary for now
RUN curl -LO https://github.com/microsoft/msquic/releases/download/v2.1.1/libmsquic_2.1.1_arm64.deb && \
    dpkg -i libmsquic_2.1.1_arm64.deb && \
    rm -f libmsquic_2.1.1_arm64.deb

RUN adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    chmod -R +x /root && \
    echo 'helixbot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env


