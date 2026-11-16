FROM library/fedora:43

ENV POWERSHELL_VERSION=7.7.0
# SHA256 of powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz
ENV POWERSHELL_SHA256=c89d9c682d2c403dfe726f3df948e359675235a5bd6fab535776de69729ca0cb

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
        ninja-build \
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

# Install PowerShell
RUN curl -L "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz" -o /tmp/powershell.tar.gz \
    && echo "${POWERSHELL_SHA256}  /tmp/powershell.tar.gz" | sha256sum -c - \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz
