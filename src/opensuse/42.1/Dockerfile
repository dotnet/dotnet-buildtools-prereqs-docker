FROM opensuse:42.1

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN zypper -n install \
        cmake \
        hostname \
        lldb-devel \
        llvm-clang \
        python-xml \
        which \
        wget \
    && ln -s /usr/bin/clang++ /usr/bin/clang++-3.5 \
    && zypper clean -a

# Install tools used by the VSO build automation.
RUN zypper -n install \
        git \
        npm \
        nodejs \
        tar \
        zip \
    && zypper clean -a \
    && npm install -g azure-cli \
    && npm cache clean

# Dependencies of CoreCLR and CoreFX.
RUN zypper -n install --force-resolution \
        glibc-locale \
        krb5-devel \
        libcurl-devel \
        libgdiplus0 \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        libopenssl-devel \
        uuid-devel \
    && zypper clean -a
