FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-build-amd64

ARG NGINX_VERSION=1.30.6

# Linux platform-test jobs build native test assets before running Nginx.
RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        binutils \
        clang \
        cmake \
        gcc-c++ \
        glibc-devel \
        kernel-headers \
        lld \
        make \
        nginx-${NGINX_VERSION} \
        zlib-ng-compat-devel \
    && dnf clean all

# Nginx opens its default error log before loading the tests' non-root configuration.
RUN ln -s /dev/stderr /var/log/nginx/error.log
