FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-build-amd64

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        clang \
    && dnf clean all
