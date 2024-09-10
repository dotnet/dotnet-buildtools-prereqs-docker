FROM mcr.microsoft.com/azurelinux/base/core:3.0
RUN tdnf install -y \
        awk \
        build-essential \
        ca-certificates \
        git \
        icu \
        pigz \
        rpm-build \
        ruby \
        # Provides useradd
        shadow-utils \
        tar \
        # Provides su
        util-linux \
        # Provides sudo
        sudo \
    && tdnf clean all \
    && gem install fpm
