FROM amd64/alpine:3.19

# Install .NET and test dependencies
RUN apk update && apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        ca-certificates \
        clang \
        clang-dev \
        cmake \
        coreutils \
        curl \
        elfutils \
        file \
        gcc \
        gettext-dev \
        git \
        icu-data-full \
        icu-dev \
        icu-libs \
        jq \
        krb5-dev \
        krb5-libs \
        libtool \
        less \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        libunwind-dev \
        linux-headers \
        lld \
        lldb-dev \
        llvm \
        lttng-ust-dev \
        make \
        ncurses-terminfo-base \
        numactl-dev \
        openssl \
        openssl-dev \
        paxctl \
        py3-lldb \
        python3-dev \
        shadow \
        sudo \
        tzdata \
        userspace-rcu \
        util-linux-dev \
        which \
        zlib-dev

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz

RUN mkdir -p /opt/microsoft/powershell/7

RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

RUN chmod +x /opt/microsoft/powershell/7/pwsh

RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
