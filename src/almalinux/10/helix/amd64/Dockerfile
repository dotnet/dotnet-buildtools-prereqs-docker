FROM library/almalinux:10

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/10/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y --allowerasing \
        cpio \
        file \
        libicu \
        libmsquic \
        python3.12 \
        sudo \
    && dnf clean all

# create helixbot user and give rights to sudo without password
RUN adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
