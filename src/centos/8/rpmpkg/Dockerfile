FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-8

# Install the rpm packaging toolchain required to build rpms
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
