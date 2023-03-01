FROM debian:bookworm

# Install Helix Dependencies

RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        at \
        build-essential \
        cmake \
        curl \
        gcc \
        gdb \
        git \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python3 -m pip install virtualenv==20.17.1 --break-system-package && \
    python3 -m pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
    python3  -m pip install ./helix_scripts-*-py3-none-any.whl --break-system-package

# Create helixbot users and give rights to sudo without password
# (we use two users here to ensure volume mounting works with two possible UIDs of the host UID)
# additionally, preinstall the virtualenv packages used for VSTS reporting to save time
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv /home/helixbot/.vsts-env
