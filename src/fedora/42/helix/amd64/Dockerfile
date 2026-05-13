FROM library/fedora:42

# Install Dependencies

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    # Add Microsoft repository for azure-cli and libmsquic packages
    && dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/fedora/42/prod/config.repo \
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
        # MSQuic from Microsoft repository
        libmsquic \
    && dnf clean all

ENV \
    # Needed for .NET libraries tests to pass
    LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot \
    && chmod +s /usr/bin/ping

USER helixbot

# Install Helix Dependencies
