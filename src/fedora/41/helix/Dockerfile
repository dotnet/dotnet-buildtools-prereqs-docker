FROM library/fedora:41

# Install Dependencies

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
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
        libunwind \
        lttng-ust \
        openssl \
        sudo \
    && dnf clean all

# Install MSQuic. Fedora 41 does not have it in the repositories, so use the Fedora 40 package

RUN dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/fedora/40/prod/config.repo \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        libmsquic

# Needed for .NET libraries tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers \
    && chmod +s /usr/bin/ping

# Setup helix virtual environment
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
