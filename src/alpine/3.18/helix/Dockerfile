FROM library/alpine:3.18 AS venv

RUN apk add --upgrade --no-cache \
        cargo \
        libffi-dev \
        linux-headers \
        python3-dev \
        openssl-dev

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
        pip install ./helix_scripts-*-py3-none-any.whl

FROM library/alpine:3.18

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

# Install libmsquic from testing repository
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ libmsquic

# Needed for runtime tests to pass
ENV LANG=en-US.UTF-8
RUN echo export LANG=${LANG}  >> /etc/profile.d/locale.sh

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies

ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=venv /venv $VIRTUAL_ENV
