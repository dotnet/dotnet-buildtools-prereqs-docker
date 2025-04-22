FROM mcr.microsoft.com/dotnet/sdk:10.0-preview

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN apt-get update \
    && apt-get install -y \
        clang-18 \
        cmake \
        gdb \
        liblldb-18-dev \
        lldb-18 \
        llvm-18 \
        locales \
        make \
        pigz \
        sudo \
    && rm -rf /var/lib/apt/lists/*

# Runtime dependencies
RUN apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        build-essential \
        cpio \
        curl \
        gettext \
        jq \
        libbrotli-dev \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libnuma-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind8-dev \
        uuid-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Dependencies for VMR/source-build tests
RUN apt-get update \
    && apt-get install -y \
        elfutils \
        file \
    && rm -rf /var/lib/apt/lists/*

# install scancode
RUN apt-get update  \
    && apt-get install -y \
        python3 \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

COPY ./install-scancode.sh /tmp
RUN /tmp/install-scancode.sh && rm -rf /tmp/install-scancode.sh