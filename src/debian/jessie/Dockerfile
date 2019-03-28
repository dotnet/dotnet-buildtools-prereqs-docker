FROM mcr.microsoft.com/dotnet-buildtools/prereqs:debian-jessie-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y wget \
    && echo "deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie main" | tee /etc/apt/sources.list.d/llvm.list \
    && echo "deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.9 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && echo "deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie-5.0 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
               clang-3.9 \
               cmake \
               gdb \
               liblldb-5.0-dev \
               lldb-5.0 \
               llvm-3.9 \
               make \
               python-lldb-5.0 \
               sudo \
    && rm -rf /var/lib/apt/lists/*
