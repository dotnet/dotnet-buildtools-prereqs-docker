FROM library/debian:bookworm AS venv

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        coreutils \
        python3-dev \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade pip setuptools \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && pip install ./helix_scripts-*-py3-none-any.whl \
    && rm ./helix_scripts-*-py3-none-any.whl

FROM library/debian:bookworm

# Install Helix Dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
        software-properties-common \
    && curl -sL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        at \
        build-essential \
        cpio \
        gcc \
        gdb \
        git \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libicu-dev \
        libmsquic \
        libssl-dev \
        libtool \
        libunwind8 \
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

ENV LANG=en_US.utf8

# Create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV \
    && ${VIRTUAL_ENV}/bin/pip install --upgrade pip setuptools 
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
