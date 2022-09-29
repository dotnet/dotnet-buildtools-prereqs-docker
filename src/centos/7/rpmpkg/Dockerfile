FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7-local

# Install the rpm packaging toolchain required to build rpms
RUN yum clean all \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby26 \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby26-ruby-devel \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby26-rubygems \
    && yum install -y \
        gcc \
        rpm-build \
    && scl enable rh-ruby26 'gem install --no-document fpm git:1.7.0 ffi:1.12.2' \
    && yum clean all
