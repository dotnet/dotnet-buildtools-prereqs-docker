FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7-local

ENV RUBY_SCL="rh-ruby26"

# Install the rpm packaging toolchain required to build rpms
RUN yum clean all \
    && yum --enablerepo=centos-sclo-rh -y install ${RUBY_SCL} \
    && yum --enablerepo=centos-sclo-rh -y install ${RUBY_SCL}-ruby-devel \
    && yum --enablerepo=centos-sclo-rh -y install ${RUBY_SCL}-rubygems \
    && yum install -y \
        gcc \
        rpm-build \
    && scl enable ${RUBY_SCL} 'gem install --no-document fpm git:1.7.0 ffi:1.12.2' \
    && yum clean all

ENV PATH="/opt/rh/${RUBY_SCL}/root/usr/local/bin:/opt/rh/${RUBY_SCL}/root/usr/bin:${PATH}" \
    LD_LIBRARY_PATH="/opt/rh/${RUBY_SCL}/root/usr/local/lib64:/opt/rh/${RUBY_SCL}/root/usr/lib64" \
    X_SCLS="scl enable ${RUBY_SCL}" \
    XDG_DATA_DIRS="/opt/rh/${RUBY_SCL}/root/usr/local/share:/opt/rh/${RUBY_SCL}/root/usr/share:/usr/local/share:/usr/share" \
    PKG_CONFIG_PATH="/opt/rh/${RUBY_SCL}/root/usr/local/lib64/pkgconfig:/opt/rh/${RUBY_SCL}/root/usr/lib64/pkgconfig"