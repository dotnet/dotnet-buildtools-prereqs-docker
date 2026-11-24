FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-build-amd64

# Host-native NativeAOT builds for testing only. Deployment artifacts require a cross-build image and compatibility sysroot.
RUN dnf update -y && \
    dnf remove -y --setopt=protected_packages= --setopt=clean_requirements_on_remove=False sudo && \
    dnf install -y --setopt=install_weak_deps=False \
        clang \
    && dnf clean all
