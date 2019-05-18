FROM alpine:3.6

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
        lttng-ust-dev \
        numactl-dev

# On 3.6, a recent version of llvm from edge/community must be used to install lldb-dev.
# Details: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/55 
# The llvm package that was installed above installs llvm4, which is also needed for tools 
# like llvm-ar during build.
RUN apk -X http://dl-cdn.alpinelinux.org/alpine/edge/community add --no-cache \
        llvm5

RUN apk -X http://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
        lldb-dev
