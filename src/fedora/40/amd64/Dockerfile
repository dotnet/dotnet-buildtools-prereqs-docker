FROM library/fedora:40

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
RUN dnf config-manager --add-repo https://packages.microsoft.com/fedora/40/prod/ && \
    rpm --import /tmp/microsoft.asc && \
    rm /tmp/microsoft.asc

# Install tools used by build automation.
RUN dnf --setopt=install_weak_deps=False install -y \
        azure-cli \
        git \
        jq \
        tar \
        procps \
        zip \
    && dnf clean all

# Install the latest non-preview powershell release.
RUN LATEST_TAG=$(curl -L https://api.github.com/repos/powershell/powershell/releases/latest | jq -r '.tag_name') \
    && curl -L https://github.com/PowerShell/PowerShell/releases/download/$LATEST_TAG/powershell-${LATEST_TAG#*v}-linux-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz

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

# Dependencies for VMR/source-build tests
RUN dnf --setopt=install_weak_deps=False install -y \
        elfutils \
        file \
    && dnf clean all

# Install ICU package to support globalization
RUN dnf --setopt=install_weak_deps=False install -y \
        icu \
    && dnf clean all

# Dependencies for Aspnetcore
RUN cd ~ && \ 
    curl -sL https://rpm.nodesource.com/setup_20.x
RUN dnf install -y nodejs && dnf clean all
ENV NO_UPDATE_NOTIFIER=true
