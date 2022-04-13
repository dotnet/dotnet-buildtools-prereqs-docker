FROM registry.access.redhat.com/ubi8/ubi

RUN dnf clean all \
    && \
    dnf install -y \
        gcc \
        rpm-build \
        ruby-devel \
        rubygems \
    && \
    gem install --no-document fpm \
    && \
    dnf clean all
