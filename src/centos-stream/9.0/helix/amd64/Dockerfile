FROM quay.io/centos/centos:stream9

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/9/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y --allowerasing \
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
        llvm \
        make \
        openssl \
        openssl-devel \
        perl \
        python3 \
        python3-devel \
        python3-pip \
        sudo \
        tar \
        wget \
        which \
    && dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && pip install ./helix_scripts-*-py3-none-any.whl

ENV LANG=en_US.utf8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m venv /home/helixbot/.vsts-env
