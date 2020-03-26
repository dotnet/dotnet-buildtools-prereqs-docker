FROM debian:stretch

# Dependencies for generic .NET Core builds and the base toolchain we need to 
# build anything (clang, cmake, make and the like)
# stretch-backports because we need CMake >= 3.14 and stretch only has 3.7
RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/stretch-backports.list \
# CMake 3.16 from stretch-backports requires libarchive13 > 3.3 and stretch-backports-sloppy is the only thing that includes that
    && echo "deb http://deb.debian.org/debian stretch-backports-sloppy main" | tee /etc/apt/sources.list.d/stretch-backports-sloppy.list \
    && apt-get update \
    && apt-get install -y \
            autoconf \
            automake \
            build-essential \
            clang \
            curl \
            g++ \
            gettext \
            gdb \
            git \
            gnupg \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblldb-3.9-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl1.0-dev \
            libssl1.0.2 \
            libtool \
            libunwind8-dev \
            lldb-3.9 \
            llvm \
            make \
            python-lldb-3.9 \
            sudo \
            tar \
            uuid-dev \
            zip \
            zlib1g-dev \
    && apt-get -t stretch-backports-sloppy install -y libarchive13 \
    && apt-get -t stretch-backports install -y cmake \
    && rm -rf /var/lib/apt/lists/*

# Install tools used by the VSO build automation.
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g azure-cli --unsafe-perm

# Until official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64
