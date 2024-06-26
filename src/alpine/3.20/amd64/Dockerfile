FROM amd64/alpine:3.20

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
        libtool \
        less \
        libgcc \
        libintl \
        libssl3 \
        libstdc++ \
        libunwind-dev \
        linux-headers \
        lld \
        lldb-dev \
        llvm \
        lttng-ust-dev \
        ncurses-terminfo-base \
        make \
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

# Install the latest non-preview powershell release.
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust \
    && LATEST_TAG=$(curl -L https://api.github.com/repos/powershell/powershell/releases/latest | jq -r '.tag_name') \
    # Verify that it's a 7.x release
    && [[ $LATEST_TAG == v7.* ]] \
    && curl -L https://github.com/PowerShell/PowerShell/releases/download/$LATEST_TAG/powershell-${LATEST_TAG#*v}-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && chmod +x /opt/microsoft/powershell/7/pwsh \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz

# Install azurecli from PIP
RUN azureEnv="/usr/local/share/azure-cli-env" && \
    python3 -m venv "$azureEnv" && \
    "$azureEnv/bin/python" -m pip install --upgrade setuptools && \
    "$azureEnv/bin/python" -m pip install azure-cli && \
    ln -s "$azureEnv/bin/az" /usr/local/bin/az
