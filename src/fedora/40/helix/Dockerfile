FROM library/fedora:40 AS venv

RUN dnf upgrade --refresh -y && \
    dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core && \
    dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        openssl \
        python3-devel \
        python3-pip \
        gcc \
        libatomic \
        redhat-rpm-config && \
    dnf clean all

RUN python3 -m venv /venv && \
    source /venv/bin/activate && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

FROM library/fedora:40

# Install Helix Dependencies

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/fedora/40/prod/config.repo \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        # Helix dependencies
        python3 \
        python3-pip \
        # Tools used by build automation
        azure-cli \
        git \
        jq \
        tar \
        redhat-rpm-config \
        procps \
        zip \
        # Runtime dependencies
        curl \
        icu \
        iputils \
        krb5-libs \
        libatomic \
        libmsquic \
        libunwind \
        lttng-ust \
        openssl \
        sudo && \
    dnf clean all

# Needed for .NET libraries tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers && \
    chmod +s /usr/bin/ping

USER helixbot

# Install Helix Dependencies

ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=venv /venv $VIRTUAL_ENV
