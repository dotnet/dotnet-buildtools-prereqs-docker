FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-build-amd64

# Host-native NativeAOT builds for testing only. Deployment artifacts require a cross-build image and compatibility sysroot.
# Clang does not pull in the linker, GCC startup objects, or C library development files on Azure Linux 3.
RUN tdnf update -y && \
    tdnf install -y \
        binutils \
        clang \
        gcc \
        glibc-devel \
    && tdnf clean all
