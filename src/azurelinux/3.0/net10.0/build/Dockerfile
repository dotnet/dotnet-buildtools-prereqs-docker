# This should be switched to 10.0 as soon as P1 ships for long-term-ness
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-azurelinux3.0

RUN tdnf install nodejs -y \
    && tdnf clean all
