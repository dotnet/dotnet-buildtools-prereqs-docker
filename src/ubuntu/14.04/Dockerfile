FROM ubuntu:14.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update && \
    apt-get install -y wget && \
    echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty main" | tee /etc/apt/sources.list.d/llvm.list && \
    echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.9 main" | tee -a /etc/apt/sources.list.d/llvm.list && \
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y \
            clang-3.9 \
            cmake \
            gdb \
            liblldb-3.9-dev \
            lldb-3.9 \
            llvm-3.9 \
            make \
            python-lldb-3.9 \
            sudo && \
    apt-get clean

# Install tools used by the VSO build automation. Set up a new apt-get source to
# get a new version of node and npm: the built-in old cert is no longer valid.
RUN wget -O - https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install -y \
            git \
            zip \
            tar \
            nodejs && \
    apt-get clean && \
    # Set unsafe-perm to true to avoid EACCES.
    npm install -g azure-cli@0.9.15 --unsafe-perm=true && \
    npm cache clean -f

# Dependencies for CoreCLR and CoreFX
RUN apt-get install -y gettext \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libunwind8-dev \
            libunwind8 \
            uuid-dev \
    && apt-get clean
