FROM arm32v7/alpine:3.13

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
        icu-dev \
        iputils \
        jq \
        krb5-dev \
        libtool \
        libunwind-dev \
        libffi-dev \
        linux-headers \
        llvm \
        lttng-ust-dev \
        make \
        openssl \
        openssl-dev \
        paxctl \
        py-cffi \
        python3-dev \
        sudo \
        tzdata \
        util-linux-dev \
        wget \
        zlib-dev

# Install Helix Dependencies

# Workaround: https://github.com/pypa/wheel/issues/367
ENV _PYTHON_HOST_PLATFORM=linux_armv7l

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==21.2.4 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# Needed for corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1001 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
