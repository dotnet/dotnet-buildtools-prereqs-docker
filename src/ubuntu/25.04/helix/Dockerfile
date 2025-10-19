FROM ubuntu.azurecr.io/ubuntu:plucky AS venv
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        cargo \
        coreutils \
        libffi-dev \
        libssl-dev \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && pip install ./helix_scripts-*-py3-none-any.whl \
    && rm ./helix_scripts-*-py3-none-any.whl

FROM ubuntu.azurecr.io/ubuntu:plucky
ARG TARGETARCH
ARG LIBMSQUIC_VERSION=2.4.8
ENV DEBIAN_FRONTEND=noninteractive

RUN LIBCURL=libcurl4 \
    && if [ "$TARGETARCH" = "arm" ]; then \
         LIBCURL="libcurl4t64"; fi \
    && apt-get update \
    && apt-get install -qq -y \
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
        libicu-dev \
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
        # libmsquic dependencies
        libbpf1 \
        libelf1t64 \
        libnl-3-200 \
        libnl-route-3-200 \
        libnuma1 \
        libxdp1 \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Add MsQuic
RUN ARCH=$TARGETARCH \
    && if [ "$TARGETARCH" = "arm" ]; then \
        ARCH="armhf"; fi \
    && curl -LO "https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/libm/libmsquic/libmsquic_${LIBMSQUIC_VERSION}_$ARCH.deb" \
    && dpkg -i libmsquic* \
    && rm libmsquic*

# Remove user (probably ubuntu) with UID 1000 to UID 2000 to avoid conflict with helixbot
RUN user_id=$(id -un 1000) && \
    /usr/sbin/userdel --force --remove $user_id

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
