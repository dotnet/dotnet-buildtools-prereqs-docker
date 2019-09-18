FROM python:3.7.3-alpine3.10

# Install .NET Core Dependencies for Alpine

RUN apk update && \
    apk add --no-cache \
        autoconf \
        bash \
        build-base \
        clang \
        clang-dev \
        cmake \
        coreutils \
        gcc \
        gettext-dev \
        git \
        icu-dev \
        iputils \
        krb5-dev \
        libtool \
        libunwind-dev \
        libffi \
        libffi-dev \
        linux-headers \
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        py-cffi \
        sudo \
        tzdata \
        util-linux-dev \
        wget \
        zlib-dev && \
    apk -X http://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev \
        numactl-dev

# Install Helix Dependencies

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==19.1 && \
    python -m pip install \ 
                  applicationinsights==0.11.7 \
                  certifi==2018.11.29 \
                  cryptography==2.5 \
                  docker==3.7.2 \
                  ndg-httpsclient==0.5.1  \
                  psutil==5.6.2 \
                  pyasn1==0.4.5 \
                  pyopenssl==18.0.0 \
                  requests==2.21.0 \
                  six==1.12.0 \
                  virtualenv==16.6.0 \
                  wheel==0.33.4 \
                  azure-devops==5.0.0b9 \
                  future==0.17.1 \
                  setuptools==41.0.1 \
                  azure-storage-blob==12.0.0b2

# Needed for corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env