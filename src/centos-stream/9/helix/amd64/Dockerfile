FROM quay.io/centos/centos:stream9

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

# Install dependencies
RUN dnf upgrade --refresh -y \
    # Required to install libunwind from the EPEL repo
    && dnf install -y epel-release \
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
        # NativeAOT and runtime dependencies
        zlib-devel \
        libunwind \
    && dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python

ENV LANG=en_US.UTF-8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot
WORKDIR /home/helixbot
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

RUN python -m venv $VIRTUAL_ENV && \
    ${VIRTUAL_ENV}/bin/pip install --upgrade pip setuptools && \
    ${VIRTUAL_ENV}/bin/pip download --no-deps --index-url $HELIX_FEED helix-scripts && \
    ${VIRTUAL_ENV}/bin/pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
