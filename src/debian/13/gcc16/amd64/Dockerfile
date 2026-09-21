FROM library/gcc:16-trixie

ENV POWERSHELL_VERSION=7.6.6
# SHA256 of powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz
ENV POWERSHELL_SHA256=ddbc4a2d113bbd46d283cfedcbcd117a70caefd7673f41f2b4e0000badf103bc

# Use Azure-hosted Debian mirror (required in network-restricted Azure build environments)
RUN find /etc/apt -maxdepth 2 \( -name "*.list" -o -name "*.sources" \) \
    -exec sed -i 's|http://deb.debian.org/debian|http://debian-archive.trafficmanager.net/debian|g' {} \;

# Dependencies for dotnet/runtime native components.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
    && curl -sL https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
        azure-cli \
        cmake \
        gdb \
        git \
        iputils-ping \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl-dev \
        liblldb-dev \
        lttng-tools \
        locales \
        locales-all \
        ninja-build \
        pigz \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install PowerShell
RUN curl -L "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz" -o /tmp/powershell.tar.gz \
    && echo "${POWERSHELL_SHA256}  /tmp/powershell.tar.gz" | sha256sum -c - \
    && mkdir -p /opt/microsoft/powershell \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell \
    && chmod +x /opt/microsoft/powershell/pwsh \
    && ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh \
    && rm -f /tmp/powershell.tar.gz

ENV LANG=en_US.UTF-8

# These symlinks are required because this docker has gcc-14 suffixed with version and gcc-16 unsuffixed in PATH.
# In the runtime repo, we (by design) give precedence to suffixed compilers before selecting unsuffixed one in PATH.
RUN ln -s $(command -v gcc) /usr/bin/gcc-16 \
    && ln -s $(command -v g++) /usr/bin/g++-16
