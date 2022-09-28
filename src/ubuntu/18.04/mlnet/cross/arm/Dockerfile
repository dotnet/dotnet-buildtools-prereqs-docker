FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-crossdeps-local

ADD rootfs.arm.tar crossrootfs

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DE19EB17684BA42D

# Install openmp support with Clang
RUN apt-get update \
    && apt-get install -y \
        clang-3.9 \
        libomp5 \
        libomp-dev

# Configure system locale
RUN update-locale LANG=en_US.UTF-8
