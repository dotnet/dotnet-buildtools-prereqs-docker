FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-build-aot-test-amd64

# Host-native NativeAOT and Nginx tests only. Deployment artifacts require a cross-build image and compatibility sysroot.
RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        nginx \
    && dnf clean all

# Nginx opens its default error log before loading the tests' non-root configuration.
RUN ln -s /dev/stderr /var/log/nginx/error.log
