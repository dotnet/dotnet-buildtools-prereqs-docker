FROM library/almalinux:8

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y  \
        'dnf-command(config-manager)' \
    # Add microsoft centos/8 repo for libmsquic.
    # (Use centos/8 rather than rhel/8 because the latter doesn't have
    #  libmsquic except in the 8.1-specific packages feed.)
    && dnf config-manager --add-repo=https://packages.microsoft.com/centos/8/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y \
        # Get recent python3 This is needed to get a pip recent enough
        # not to fail the build when installing cryptography library as
        # a dependency of the helix scripts.
        python39 \
        # Required for asp.net core test runs
        sudo \
        libicu \
        libmsquic \
        # Required for arcade test runs
        cpio \
        file \
    && dnf clean all

# Aspnetcore test runs expect python to be available without version suffix
RUN alternatives --set python /usr/bin/python3 \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
RUN adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

# Setup helix virtual environment
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
