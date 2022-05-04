FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7

# Install the rpm packaging toolchain required to build rpms
RUN yum clean all
RUN yum --enablerepo=centos-sclo-rh -y install rh-ruby25
RUN yum --enablerepo=centos-sclo-rh -y install rh-ruby25-ruby-devel
RUN yum --enablerepo=centos-sclo-rh -y install rh-ruby25-rubygems
RUN yum install -y \
        gcc \
        rpm-build
RUN rh-ruby25-gem install --no-document \
        git:1.7.0 \
        ffi:1.12.2
RUN scl enable rh-ruby25 'gem install --no-document fpm'
RUN yum clean all

