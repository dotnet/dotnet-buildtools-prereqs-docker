FROM mcr.microsoft.com/dotnet-buildtools/prereqs:debian-jessie-coredeps

# Install tools needs to build CoreRT.
RUN apt-get update \
    && apt-get install -y wget \
    && echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.6 main" | tee /etc/apt/sources.list.d/llvm36.list \
    && echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.9 main" | tee /etc/apt/sources.list.d/llvm39.list \
    && wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
               clang-3.9 \
               cmake \
               lldb-3.6 \
               lldb-3.6-dev \
               llvm-3.9-dev \
               make \
    && rm -rf /var/lib/apt/lists/*
