FROM alpine:3.12

# Install .NET Core Dependencies for Alpine

RUN apk update && \
    apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        clang \
        clang-dev \
        cmake \
        coreutils \
        curl \
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
        py-cffi \
        python3 \
        python3-dev \
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
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==20.1.1 && \
    python -m pip install virtualenv==16.6.0 && \
    python -m pip install helix-scripts --extra-index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple

# Needed for corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env