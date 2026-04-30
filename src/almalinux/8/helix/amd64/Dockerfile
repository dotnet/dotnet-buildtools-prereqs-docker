FROM library/almalinux:8

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y  \
        'dnf-command(config-manager)' \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/8/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y \
        # Get recent python3 This is needed to get a pip recent enough
        # not to fail the build when installing cryptography library as
        python39 \
        # Required for asp.net core test runs
        sudo \
        libicu \
        libmsquic \
        # Required for arcade test runs
        cpio \
        file \
    && dnf clean all

# Test runs expect python to be available without version suffix
RUN alternatives --set python /usr/bin/python3 \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
RUN adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot
WORKDIR /home/helixbot

