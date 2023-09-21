FROM mcr.microsoft.com/dotnet/sdk:6.0-focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        binutils \
        dwarfdump \
        git \
     && rm -rf /var/lib/apt/lists/* \
     && dotnet tool install --global dotnet-symbol
