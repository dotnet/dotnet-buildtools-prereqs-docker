FROM opensuse:42.3

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN zypper -n install \
        cmake \
        gcc-c++ \
        hostname \
        lldb-devel \
        llvm-clang \
        llvm-devel \
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
    && zypper clean -a

RUN npm install -g azure-cli

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

# Until OpenSuse.42.3 official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64
