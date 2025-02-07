FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-azurelinux3.0

RUN tdnf install -y \
        nodejs \
        shadow-utils \
    && tdnf clean all
