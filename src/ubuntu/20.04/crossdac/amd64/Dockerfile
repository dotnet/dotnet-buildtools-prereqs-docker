FROM mcr.microsoft.com/dotnet/core/sdk:3.1-focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        binutils \
        dwarfdump \
        git \
     && rm -rf /var/lib/apt/lists/* \
     && dotnet tool install --global dotnet-symbol
