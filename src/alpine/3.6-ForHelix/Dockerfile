FROM alpine:3.6

COPY ./setup-Alpine.sh /home/src/setup-Alpine.sh
RUN chmod a+x /home/src/setup-Alpine.sh

RUN apk update

RUN apk add --no-cache \
        autoconf \
        bash \
        build-base \
        clang \
        clang-dev \
        cmake \
        coreutils \
        curl-dev \
        gcc \
        gettext-dev \
        git \
        icu-dev \
        iputils \
        krb5-dev \
        libtool \
        libunwind-dev \
        libffi \
        linux-headers \
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        py-cffi \
        python \
        python-dev \
        sudo \
        tzdata \
        util-linux-dev \
        wget \
        zlib-dev

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
        lldb-dev

RUN /usr/sbin/adduser -D -G adm -s /bin/sh helixbot

# Restore pip and set environment
RUN wget -O /home/helixbot/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
        /usr/bin/python /home/helixbot/get-pip.py
ENV pkgmgr apk
ENV HELIX_SCRIPT_ROOT /home/helixbot/dotnetbuild/scripts
ENV HELIX_WORK_ROOT /home/helixbot/dotnetbuild/work
ENV HELIX_LOG_ROOT /home/helixbot/dotnetbuild/logs
ENV HELIX_CONFIG_ROOT /home/helixbot/dotnetbuild/config
ENV PYTHONPATH /usr/bin/python:/home/helixbot/dotnetbuild/scripts
ENV HELIX_PYTHONPATH /usr/bin/python
WORKDIR /home/helixbot/

# Run script that generates starttestrunner.sh
RUN /home/src/setup-Alpine.sh
USER helixbot
