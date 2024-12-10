FROM library/debian:trixie AS base

RUN apt-get update

FROM base AS venv

RUN apt-get install -y \
        coreutils \
        python3-dev \
        python3-pip \
        python3-venv

RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && pip install ./helix_scripts-*-py3-none-any.whl

FROM base
ARG TARGETARCH

# Install Helix Dependencies
RUN LIBCURL=libcurl4 \
    && if [ "$TARGETARCH" = "arm" ]; then \
           LIBCURL="libcurl4t64"; fi \ 
    && apt-get install -y \
        apt-transport-https \
        curl \
        autoconf \
        automake \
        at \
        build-essential \
        gcc \
        gdb \
        git \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libicu-dev \
        libnuma1 \
        libssl-dev \
        libtool \
        libunwind8 \
        lldb \
        llvm \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN curl -O https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/libm/libmsquic/libmsquic_2.4.7_$TARGETARCH.deb \
    && dpkg -i libmsquic* \
    && rm libmsquic*

ENV LANG=en_US.utf8

# Create helixbot user and give rights to sudo without password
# additionally, preinstall the virtualenv packages used for VSTS reporting to save time
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

# Install Helix Dependencies

ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=venv /venv $VIRTUAL_ENV
