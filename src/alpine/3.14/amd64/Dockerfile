FROM alpine:3.14

RUN apk update

RUN apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        clang \
        clang-dev \
        cmake \
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
        lld \
        llvm \
        lttng-ust-dev \
        make \
        numactl-dev \
        openssl \
        openssl-dev \
        paxctl \
        python3 \
        python3-dev \
        shadow \
        sudo \
        util-linux-dev \
        which \
        zlib-dev

RUN ln -sf /usr/bin/python3 /usr/bin/python
