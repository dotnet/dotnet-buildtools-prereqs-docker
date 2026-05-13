FROM quay.io/centos/centos:stream10

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/10/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y --allowerasing \
        autoconf \
        automake \
        curl \
        file \
        git-core \
        iputils \
        libicu \
        libmsquic \
        libtool \
        lldb \
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

ENV LANG=en_US.UTF-8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
