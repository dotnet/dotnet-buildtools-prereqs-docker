FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-android-amd64

RUN dnf update -y \
    && dnf install --setopt=install_weak_deps=False -y \
        docker-buildx \
        docker-cli
