FROM mcr.microsoft.com/dotnet-buildtools/prereqs:debian-stretch

# Dependencies for generic .NET Core builds and the base toolchain we need to 
# build anything (clang, cmake, make and the like)
# stretch-backports because we need CMake >= 3.14 and stretch only has 3.7
RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/stretch-backports.list \
# CMake 3.16 from stretch-backports requires libarchive13 > 3.3 and stretch-backports-sloppy is the only thing that includes that
    && echo "deb http://deb.debian.org/debian stretch-backports-sloppy main" | tee /etc/apt/sources.list.d/stretch-backports-sloppy.list \
    && apt-get update \
    && apt-get remove --purge -y \
            cmake \
            libarchive13 \
    && apt-get autoremove -y \
    && apt-get -t stretch-backports-sloppy install -y libarchive13 \
    && apt-get -t stretch-backports install -y cmake \
    && rm -rf /var/lib/apt/lists/*
