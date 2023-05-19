FROM quay.io/centos/centos:stream9-development

# Install dependencies
RUN curl -LO https://packages.microsoft.com/keys/microsoft.asc && \
    echo 2cfd20a306b2fa5e25522d78f2ef50a1f429d35fd30bd983e2ebffc2b80944fa microsoft.asc| sha256sum --check - && \
    rpm --import microsoft.asc && \
    rm microsoft.asc && \
    dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
    && \
    dnf config-manager --set-enabled crb \
    && \
    dnf install --setopt tsflags=nodocs -y --allowerasing \
        autoconf \
        automake \
        curl \
        file \
        gcc \
        gcc-c++ \
        gdb \
        git-core \
        iputils \
        libicu \
        libmsquic \
        libtool \
        make \
        openssl \
        openssl-devel \
        perl \
        python3 \
        python3-devel \
        sudo \
        tar \
        wget \
        which \
    && \
    dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

ENV LANG=en_US.utf8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
