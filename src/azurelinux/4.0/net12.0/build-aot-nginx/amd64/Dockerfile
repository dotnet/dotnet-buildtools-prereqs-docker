FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-build-aot-amd64

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        nginx \
    && dnf clean all

# Nginx opens its default error log before loading the tests' non-root configuration.
RUN ln -s /dev/stderr /var/log/nginx/error.log
