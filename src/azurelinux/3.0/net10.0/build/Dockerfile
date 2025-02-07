# This should be switched to 10.0 stable and then non-preview
FROM mcr.microsoft.com/dotnet/nightly/runtime-deps:10.0-preview-azurelinux3.0

RUN tdnf install nodejs -y \
    && tdnf clean all
