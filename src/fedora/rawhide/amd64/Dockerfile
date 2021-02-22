FROM registry.fedoraproject.org/fedora:rawhide

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y \
        clang \
        cmake \
        findutils \
        gdb \
        glibc-langpack-en \
        lldb-devel \
        llvm-devel \
        make \
        python \
        which \
    && dnf clean all

# Install tools used by build automation.
RUN dnf install -y \
        git \
        tar \
        procps \
        zip \
    && dnf clean all

# Dependencies of CoreCLR, Mono and CoreFX.
RUN dnf install -y \
        autoconf \
        automake \
        glibc-locale-source \
        iputils \
        krb5-devel \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libtool \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
        uuid-devel \
        zlib-devel \
    && dnf clean all
