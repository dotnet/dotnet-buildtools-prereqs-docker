FROM amd64/alpine:3.21

RUN apk add --upgrade --no-cache \
        # Install .NET and test dependencies
        autoconf \
        automake \
        bash \
        build-base \
        brotli-dev \
        ca-certificates \
        clang \
        clang-dev \
        cmake \
        coreutils \
        cpio \
        curl \
        elfutils \
        file \
        gcc \
        gettext-dev \
        git \
        icu-data-full \
        icu-dev \
        icu-libs \
        iproute2 \
        jq \
        krb5-dev \
        less \
        libgcc \
        libintl \
        libssl3 \
        libstdc++ \
        libtool \
        libunwind-dev \
        linux-headers \
        lld \
        lldb-dev \
        llvm \
        lttng-ust-dev \
        ncurses-terminfo-base \
        make \
        openssl \
        openssl-dev \
        paxctl \
        pigz \
        py3-lldb \
        py3-pip \
        python3-dev \
        shadow \
        sudo \
        tzdata \
        userspace-rcu \
        util-linux-dev \
        which \
        zlib-dev \
        \
        # Azure DevOps container job requirements
        nodejs

# Install the latest non-preview powershell release.
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust \
    && LATEST_TAG=$(curl -L https://api.github.com/repos/powershell/powershell/releases/latest | jq -r '.tag_name') \
    && curl -L https://github.com/PowerShell/PowerShell/releases/download/$LATEST_TAG/powershell-${LATEST_TAG#*v}-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz

# Install azurecli from PIP
RUN azureEnv="/usr/local/share/azure-cli-env" \
    && python3 -m venv "$azureEnv" \
    && "$azureEnv/bin/python" -m pip install --upgrade setuptools \
    && "$azureEnv/bin/python" -m pip install azure-cli \
    && ln -s "$azureEnv/bin/az" /usr/local/bin/az

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"
