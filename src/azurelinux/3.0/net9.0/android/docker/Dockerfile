FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-android-net9.0-local

RUN tdnf update -y \
    && tdnf install -y \
        moby-engine \
        moby-cli
