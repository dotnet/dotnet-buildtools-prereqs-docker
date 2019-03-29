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

# On 3.6, a recent version of llvm from edge/main must be used to install lldb.
# Details: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/55 
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev \
        llvm
