FROM ubuntu.azurecr.io/ubuntu:noble AS venv
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        cargo \
        pkg-config \
        libffi-dev \
        coreutils \
        python3-dev \
        python3-pip \
        python3-venv \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

FROM ubuntu.azurecr.io/ubuntu:noble
ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN LIBCURL=libcurl4 && \
    if [ "$TARGETARCH" = "arm" ]; then \
        LIBCURL="libcurl4t64"; fi && \ 
    apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        clang \
        curl \
        gcc \
        gdb \
        git \
        gss-ntlmssp \
        iputils-ping \
        $LIBCURL \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        libnuma1 \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb \
        llvm \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        python3-venv \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Add MsQuic
# MsQuic does not yet publish packages for 24.04
# Manually install 22.04 package for now
RUN DEPS= && \
    ARCH=$TARGETARCH && \
    if [ "$TARGETARCH" = "arm" ]; then \
        DEPS=--ignore-depends=libssl3 && \
        ARCH=armhf ; fi && \
    curl -LO https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/libm/libmsquic/libmsquic_2.3.6_$ARCH.deb && \
    dpkg $DEPS -i libmsquic_*.deb && \
    rm -f libmsquic_*.deb

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

# Install Helix Dependencies

ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=venv /venv $VIRTUAL_ENV

