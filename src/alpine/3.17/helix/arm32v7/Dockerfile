FROM arm32v7/alpine:3.17 as msquic

# build MsQuic as we don't have packages
RUN apk add --upgrade --no-cache \
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
        perl

RUN git clone --depth 1 --single-branch --branch v2.3.6 --recursive https://github.com/microsoft/msquic /tmp/msquic

WORKDIR /tmp/msquic

RUN cmake -B build/linux/arm_Release_openssl3 \
       -DQUIC_OUTPUT_DIR=/tmp/msquic/artifacts/bin/linux/arm_Release_openssl3 \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_TARGET_ARCHITECTURE=arm \
       -DQUIC_TLS=openssl3 \
       -DQUIC_ENABLE_LOGGING=true \
       -DQUIC_USE_SYSTEM_LIBCRYPTO=true \
       -DQUIC_BUILD_TOOLS=off \
       -DQUIC_BUILD_TEST=off \
       -DQUIC_BUILD_PERF=off && \
    cmake --build build/linux/arm_Release_openssl3  --config Release && \
    cmake --install build/linux/arm_Release_openssl3 --prefix /msquic


FROM arm32v7/alpine:3.17

# Install .NET and test dependencies
RUN apk add --upgrade --no-cache \
        bash \
        coreutils \
        curl \
        icu-data-full \
        icu-libs \
        iputils \
        krb5-libs \
        lldb \
        llvm \
        lttng-ust \
        musl-locales \
        numactl \
        openssl \
        python3 \
        py3-pip \
        sudo \
        tzdata

# Install Helix Dependencies
RUN apk add --upgrade --no-cache \
        cargo \
        libffi-dev \
        linux-headers \
        python3-dev \
        openssl-dev && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl && \
    apk del \
        cargo \
        libffi-dev \
        linux-headers \
        python3-dev \
        openssl-dev

# Copy msquic from the msquic image into our image that will run on Helix
COPY --from=msquic /msquic /usr

# Needed for runtime tests to pass
ENV LANG=en-US.UTF-8
RUN echo export LANG=${LANG}  >> /etc/profile.d/locale.sh

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python3 -m venv /home/helixbot/.vsts-env
