FROM mcr.microsoft.com/azurelinux/core:4
RUN dnf update -y && \
    dnf install -y \
        autoconf \
        automake \
        gawk \
        gcc \
        gcc-c++ \
        make \
        ca-certificates \
        git \
        icu \
        libtool \
        openssl \
        rpm-build \
        ruby \
        # Provides useradd
        shadow-utils \
        tar \
        # Provides su
        util-linux \
        pam \
        # Provides sudo
        sudo \
    && dnf clean all \
    && gem install fpm
