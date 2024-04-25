FROM alpine:3.16

RUN apk update && \
    apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        cargo \
        clang \
        clang-dev \
        cmake \
        coreutils \
        curl \
        gcc \
        gettext-dev \
        git \
        icu-data-full \
        icu-dev \
        iputils \
        jq \
        krb5-dev \
        libffi-dev \
        libtool \
        libunwind-dev \
        linux-headers \
        lld \
        lldb-dev \
        llvm \
        lttng-ust-dev \
        make \
        musl-locales \
        numactl-dev \
        openssl \
        openssl-dev \
        paxctl \
        py3-lldb \
        python3-dev \
        rust \
        shadow \
        sudo \
        tzdata \
        util-linux-dev \
        which \
        zlib-dev

# Install Helix Dependencies

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==22.2.2 && \
    python -m pip install virtualenv==20.16.5 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# build MsQuic as we don't have packages
RUN apk update && apk add --no-cache && \
    apk add \
        cmake \
        g++ \
        gcc \
        git \
        numactl-dev \
        linux-headers \
        lttng-ust-dev \
        make \
        musl-dev \
        openssl-dev \
        perl && \
    cd /tmp && \
    git clone --depth 1 --single-branch --branch main --recursive https://github.com/microsoft/msquic && \
    cd msquic && \
    cmake -B build/linux/x64_openssl \
       -DQUIC_OUTPUT_DIR=/tmp/msquic/src/msquic/artifacts/bin/linux/x64_Release_openssl \
       -DCMAKE_BUILD_TYPE=Release \
       -DQUIC_TLS=openssl \
       -DQUIC_ENABLE_LOGGING=true \
       -DQUIC_USE_SYSTEM_LIBCRYPTO=true \
       -DQUIC_BUILD_TOOLS=off \
       -DQUIC_BUILD_TEST=off \
       -DQUIC_BUILD_PERF=off && \
    cmake --build build/linux/x64_openssl  --config Release && \
    cp artifacts/bin/linux/x64_Release_openssl/libmsquic.so.* artifacts/bin/linux/x64_Release_openssl/libmsquic.lttng.so.* /usr/lib && \
    ldd artifacts/bin/linux/x64_Release_openssl/libmsquic.so.* && \
    rm -rf /tmp/msquic && \
    apk del \
        cmake \
        g++ \
        gcc \
        git \
        linux-headers \
        lttng-ust-dev \
        make \
        musl-dev \
        openssl-dev \
        perl

# Needed for corefx tests to pass
ENV LANG=en-US.UTF-8
RUN echo export LANG=${LANG}  >> /etc/profile.d/locale.sh

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python -m virtualenv /home/helixbot/.vsts-env
