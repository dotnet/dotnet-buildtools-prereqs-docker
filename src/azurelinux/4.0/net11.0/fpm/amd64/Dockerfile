FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0
RUN dnf update -y && \
    dnf install -y \
        gawk \
        gcc \
        make \
        ca-certificates \
        git \
        icu \
        rpm-build \
        ruby \
        # Provides useradd
        shadow-utils \
        tar \
        # Provides su
        util-linux \
        # Provides sudo
        sudo \
    && dnf clean all \
    && gem install fpm
