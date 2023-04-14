FROM mcr.microsoft.com/cbl-mariner/base/core:2.0
RUN tdnf install -y \
        awk \
        ca-certificates \
        icu \
        rpm-build \
        ruby \
        # Provides useradd
        shadow-utils \
        tar \
        # Provides su
        util-linux \
        git \
    && tdnf clean all \
    && gem install fpm
