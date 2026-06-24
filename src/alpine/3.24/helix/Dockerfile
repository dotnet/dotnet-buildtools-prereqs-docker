FROM library/alpine:3.24 AS venv

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

RUN apk add --upgrade --no-cache \
        cargo \
        python3-dev \
        build-base \
        libffi-dev \
        openssl-dev \
        gcc \
        linux-headers

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps --index-url $HELIX_FEED helix-scripts && \
        pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl && \
        rm ./helix_scripts-*-py3-none-any.whl

FROM library/alpine:3.24

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

# Install .NET and test dependencies
RUN apk add --upgrade --no-cache \
        bash \
        coreutils \
        curl \
        icu-data-full \
        icu-libs \
        iputils \
        krb5-libs \
        libmsquic \
        lldb \
        llvm \
        lttng-ust \
        musl-locales \
        openssl \
        python3 \
        python3-dev \
        py3-pip \
        sudo \
        tzdata

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
