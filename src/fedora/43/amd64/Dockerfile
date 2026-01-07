FROM library/fedora:43

RUN dnf upgrade --refresh -y \
    && dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/fedora/43/prod/config.repo \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        # Base toolchain we need to build anything (clang, cmake, make and the like)
        clang \
        cmake \
        dnf-plugins-core \
        findutils \
        gdb \
        glibc-langpack-en \
        lldb-devel \
        llvm-devel \
        make \
        pigz \
        python \
        which \
        # Tools used by build automation
        azure-cli \
        git \
        jq \
        tar \
        procps \
        zip \
        # Dependencies of CoreCLR, Mono and CoreFX
        autoconf \
        automake \
        brotli-devel \
        cpio \
        glibc-locale-source \
        iputils \
        krb5-devel \
        libcurl-devel \
        libicu-devel \
        libomp-devel \
        libtool \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        openssl-devel \
        rapidjson-devel \
        uuid-devel \
        zlib-devel \
        # Dependencies for VMR/source-build tests
        iproute \
        elfutils \
        file \
        # Dependencies to support globalization
        icu \
    && dnf clean all

# Install the latest non-preview powershell release.
RUN LATEST_TAG=$(curl -L https://api.github.com/repos/powershell/powershell/releases/latest | jq -r '.tag_name') \
    && curl -L https://github.com/PowerShell/PowerShell/releases/download/$LATEST_TAG/powershell-${LATEST_TAG#*v}-linux-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz
