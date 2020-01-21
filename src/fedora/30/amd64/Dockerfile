FROM fedora:30

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
        python2-lldb \
        sudo \
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
        compat-openssl10-devel \
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
        uuid-devel \
    && dnf clean all
