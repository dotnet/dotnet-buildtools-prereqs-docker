FROM registry.fedoraproject.org/fedora:35

RUN sleep 30
RUN cat /etc/resolv.conf
RUN curl -v http://google.com/
RUN curl -v http://fedora.org/
RUN curl -vL http://mirrors.fedoraproject.org/

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
    && dnf clean all
