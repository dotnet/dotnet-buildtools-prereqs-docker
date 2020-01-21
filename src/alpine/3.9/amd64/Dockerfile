FROM alpine:3.9

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
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        python \
        shadow \
        sudo \
        util-linux-dev \
        which \
        zlib-dev

RUN apk -X http://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        cmake \
        userspace-rcu-dev \
        lttng-ust-dev \
        numactl-dev
