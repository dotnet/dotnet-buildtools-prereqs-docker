FROM microsoft/dotnet-buildtools-prereqs:debian-8.2-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y wget \
    && echo "deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie main" | tee /etc/apt/sources.list.d/llvm.list \
    && echo "deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.9 main" | tee -a /etc/apt/sources.list.d/llvm.list \
    && wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
               clang-3.5 \
               clang-3.9 \
               cmake \
               liblldb-3.9-dev \
               lldb-3.9 \
               llvm-3.5 \
               llvm-3.9 \
               make \
    && rm -rf /var/lib/apt/lists/*
