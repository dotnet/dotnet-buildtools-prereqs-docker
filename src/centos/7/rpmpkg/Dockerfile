FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7

# Install the rpm packaging toolchain we need to build rpms
RUN yum install -y \
        gcc \
        make \
        rpm-build \
        ruby-devel \
        rubygems \
        sudo \
    && gem install --no-document fpm
