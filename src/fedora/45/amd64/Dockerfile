FROM library/fedora:45

ENV POWERSHELL_VERSION=7.6.3

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
        # Python 3.14 hosts azure-cli (installed via pip below)
        python3.14 \
        which \
        # Tools used by build automation
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

# Install azure-cli from pip into a dedicated Python 3.14 virtual environment.
# Fedora 45's default Python is 3.15 (beta), for which the distro azure-cli RPM
# won't resolve and azure-cli's native deps have no prebuilt wheels. Python 3.14
# has wheels for those deps, so install azure-cli there and symlink az.
RUN azureEnv="/usr/local/share/azure-cli-env" \
    && python3.14 -m venv "$azureEnv" \
    && "$azureEnv/bin/python" -m pip install --upgrade pip setuptools \
    && "$azureEnv/bin/python" -m pip install azure-cli \
    && ln -s "$azureEnv/bin/az" /usr/local/bin/az

# Install PowerShell
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz
