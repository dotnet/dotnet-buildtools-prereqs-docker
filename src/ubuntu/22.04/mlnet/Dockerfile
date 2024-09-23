FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04

# Install openmp support
RUN apt-get update \
    && apt-get install -y \
        libomp5 \
        libomp-dev \
    && rm -rf /var/lib/apt/lists/*
