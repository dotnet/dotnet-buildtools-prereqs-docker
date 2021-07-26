FROM alpine:3.13

RUN apk update

RUN apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        clang \
        clang-dev \
        coreutils \
        curl \
        curl-dev \
        gcc \
        gettext-dev \
        git \
        icu-dev \
        krb5-dev \
        libtool \
        libunwind-dev \
        linux-headers \
        lldb \
        lldb-dev \
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        py3-lldb \
        python2 \
        python3 \
        python3-dev \
        shadow \
        sudo \
        util-linux-dev \
        which \
        zlib-dev

RUN apk -X http://dl-cdn.alpinelinux.org/alpine/v3.13/main add --no-cache \
        cmake && \
    apk -X http://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev \
        numactl-dev
