FROM arm64v8/ubuntu:16.04

# Install Helix Dependencies

RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        build-essential \
        gss-ntlmssp \
        iputils-ping \
        libcurl3 \
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
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==19.3.1 && \
    python -m pip install virtualenv==16.6.0 && \
    python -m pip install helix-scripts --extra-index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple

RUN adduser --disabled-password --gecos '' --uid 1001 --shell /bin/bash --ingroup adm helixbot && \
    chmod -R +x /root && \
    echo 'helixbot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env


