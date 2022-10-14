FROM debian:buster

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
        liblttng-ust-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        locales \
        locales-all \
        procps \
        python3-dev \
        python3-pip \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
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

# Add MsQuic
RUN curl -LO https://packages.microsoft.com/keys/microsoft.asc && \
    echo 2cfd20a306b2fa5e25522d78f2ef50a1f429d35fd30bd983e2ebffc2b80944fa microsoft.asc| sha256sum --check - && \
    apt-key add microsoft.asc && \
    apt-add-repository https://packages.microsoft.com/debian/10/prod && \
    apt-get update && \
    apt-get install libmsquic && \
    rm -rf /var/lib/apt/lists/* microsoft.asc

# Create helixbot user and give rights to sudo without password
# (we use two users here to ensure volume mounting works with two possible UIDs of the host UID)
# additionally, preinstall the virtualenv packages used for VSTS reporting to save time
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot2 && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers && \
    echo "helixbot2 ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
