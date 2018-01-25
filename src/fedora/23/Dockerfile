FROM fedora:23

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y cmake \
        clang \
        lldb-devel \
        make \
        which && \
    dnf clean all

# Install tools used by the VSO build automation.
RUN dnf install -y git \
        zip \
        tar \
        nodejs \
        npm && \
    dnf clean all && \
    npm install -g azure-cli@0.9.20 && \
    npm cache clean

# Dependencies of CoreCLR and CoreFX.
RUN dnf install -y \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
    && dnf clean all
