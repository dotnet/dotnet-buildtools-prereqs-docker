FROM arm32v7/alpine:3.9

RUN apk update

RUN apk add --no-cache \
        autoconf \
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
        llvm5 \
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
        userspace-rcu-dev \
        lttng-ust-dev

# numactl-dev is missing on arm32, we need to build it from sources
RUN apk add --no-cache git automake
RUN git clone https://github.com/numactl/numactl.git
RUN (cd numactl; ./autogen.sh && ./configure && make && make install)

RUN apk -X http://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
        lldb-dev
