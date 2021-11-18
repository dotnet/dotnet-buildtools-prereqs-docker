FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-8

# Install CMake 3.15.5

RUN wget -O cmake-install.sh https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.sh && \
    bash ./cmake-install.sh --skip-license --exclude-subdir --prefix=/usr/local && \
    rm ./cmake-install.sh
