FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# sources tweak is to work around very slow update

RUN apt-get clean && \
    mv /etc/apt/sources.list /etc/apt/sources.list1 && apt-get update && \
    mv /etc/apt/sources.list1 /etc/apt/sources.list &&  apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        clang \
        gcc \
        gdb \
        git \
        gss-ntlmssp \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        libnode-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb-3.9 \
        locales \
        locales-all \
        node-gyp \
        npm \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
        unzip \
     && rm -rf /var/lib/apt/lists/* \
     \
     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

# Install V8 & other engines in the non-root context

# This gets an ignorable warning described in https://github.com/sudo-project/sudo/issues/42
RUN sudo npm install jsvu -g && \
    jsvu --os=linux64 --engines=all

ENV PATH="/home/helixbot/.jsvu:${PATH}"

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env