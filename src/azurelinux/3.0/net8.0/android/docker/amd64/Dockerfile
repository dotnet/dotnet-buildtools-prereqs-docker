FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-android-amd64

RUN tdnf update -y \
    && tdnf install -y \
        moby-engine \
        moby-cli
