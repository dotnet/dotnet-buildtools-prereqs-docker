FROM mcr.microsoft.com/cbl-mariner/base/core:2.0
RUN tdnf install -y \
        ruby \
    && tdnf clean all \
    && gem install fpm
