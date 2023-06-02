FROM fedora:38

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf --setopt=install_weak_deps=False install -y \
        clang \
        cmake \
        dnf-plugins-core \
        findutils \
        gdb \
        glibc-langpack-en \
        lldb-devel \
        llvm-devel \
        make \
        python \
        which \
    && dnf clean all

# Add MS package repo.
COPY  microsoft.asc /tmp
RUN dnf config-manager --add-repo https://packages.microsoft.com/fedora/36/prod/ && \
    rpm --import /tmp/microsoft.asc && \
    rm /tmp/microsoft.asc

# Install tools used by build automation.
RUN dnf --setopt=install_weak_deps=False install -y \
        git \
        tar \
        procps \
        zip \
    && dnf clean all

# Dependencies of CoreCLR, Mono and CoreFX.
RUN dnf --setopt=install_weak_deps=False install -y \
        autoconf \
        automake \
        glibc-locale-source \
        iputils \
        jq \
        krb5-devel \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libomp-devel \
        libtool \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
        uuid-devel \
        zlib-devel \
    && dnf clean all

# Dependencies for running the VMR tooling
# LibGit2Sharp requires this when synchronizing the VMR in a Codespace
RUN dnf --setopt=install_weak_deps=False install -y \
        openssl1.1 \
    && dnf clean all
