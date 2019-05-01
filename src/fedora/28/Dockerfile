FROM fedora:28

# Workaround to avoid NuGet restore timeout
RUN dnf upgrade -y nss \
    && dnf clean all

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y \
        clang \
        cmake \
        findutils \
        gdb \
        lldb-devel \
        llvm-devel \
        make \
        python \
        python2-lldb \
        sudo \
        which \
    && dnf clean all

# Install tools used by the VSO build automation.
RUN dnf install -y \
        git \
        npm \
        nodejs \
        tar \
        zip \
    && dnf clean all

RUN npm install -g azure-cli --unsafe-perm

# Dependencies of CoreCLR and CoreFX.
RUN dnf install -y \
        compat-openssl10-devel \
        glibc-locale-source \
        iputils \
        krb5-devel \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        numactl-devel \
        uuid-devel \
    && dnf clean all

# Until official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64
