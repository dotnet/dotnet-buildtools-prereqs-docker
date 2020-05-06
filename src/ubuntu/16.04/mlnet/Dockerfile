FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04

# Install openmp support with Clang
RUN apt-get update \
    && apt-get install -y libomp-9-dev

# Configure system locale
RUN update-locale LANG=en_US.UTF-8
