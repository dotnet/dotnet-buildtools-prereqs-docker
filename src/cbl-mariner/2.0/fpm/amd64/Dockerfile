FROM mcr.microsoft.com/cbl-mariner/base/core:2.0
RUN tdnf install -y \
        ruby \
        # Provides useradd, needed by Azure DevOps
        shadow-utils \
        # Provides su, needed by Azure DevOps
        util-linux \
    && tdnf clean all \
    && gem install fpm
