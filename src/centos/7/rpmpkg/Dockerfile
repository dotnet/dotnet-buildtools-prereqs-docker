FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7

# Install the rpm packaging toolchain required to build rpms
RUN yum clean all \
    && yum install -y \
        gcc \
        rpm-build \
        ruby-devel \
        rubygems \
    && gem install --no-document \
        git:1.7.0 \
        ffi:1.12.2 \
        fpm \
    && yum clean all

