FROM fedora:24

# Workaround to avoid NuGet restore timeout
RUN dnf upgrade -y nss \
    && dnf clean all

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y \
        clang \
        cmake \
        lldb-devel \
        llvm-devel \
        make \
        python \
        which \
    && dnf clean all

# Install tools used by the VSO build automation.
RUN dnf install -y \
        git \
        npm \
        nodejs \
        tar \
        zip \
    && dnf clean all \
    && npm install -g azure-cli \
    && npm cache clean

# Dependencies of CoreCLR and CoreFX.
RUN dnf install -y \
        glibc-locale-source \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
        uuid-devel \
    && dnf clean all
