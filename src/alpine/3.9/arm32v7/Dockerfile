FROM arm32v7/alpine:3.9

# Workaround: https://github.com/pypa/wheel/issues/367
ENV _PYTHON_HOST_PLATFORM linux_armv7l

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
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        python \
        python3 \
        python3-dev \
        shadow \
        sudo \
        util-linux-dev \
        which \
        zlib-dev

RUN apk -X http://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev
