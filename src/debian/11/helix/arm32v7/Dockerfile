FROM library/debian:bullseye

# Workaround: https://github.com/pypa/wheel/issues/367
ENV _PYTHON_HOST_PLATFORM=linux_armv7l

# Install Helix Dependencies

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
        software-properties-common \
    && curl -sL https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
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
        libmsquic \
        libssl-dev \
        libtool \
        libunwind8 \
        llvm \
        locales \
        locales-all \
        python3-cryptography \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && export CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    && pip install ./helix_scripts-*-py3-none-any.whl

# Create helixbot user and give rights to sudo without password
# (we use two users here to ensure volume mounting works with two possible UIDs of the host UID)
# additionally, preinstall the virtualenv packages used for VSTS reporting to save time
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot \
    && /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot2 \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers \
    && echo "helixbot2 ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m venv /home/helixbot/.vsts-env
