FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7

# Install the rpm packaging toolchain required to build rpms
RUN yum clean all \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby25 \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby25-ruby-devel \
    && yum --enablerepo=centos-sclo-rh -y install rh-ruby25-rubygems \
    && yum install -y \
        gcc \
        rpm-build \
    && scl enable rh-ruby25 'gem install --no-document fpm git:1.7.0 ffi:1.12.2' \
    && yum clean all
