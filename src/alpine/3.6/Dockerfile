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

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev

# Currently apk cannot find lldb for 3.8, and this is not required for execution so leaving it commented out.
# Details: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/55 
#RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
#        lldb-dev
