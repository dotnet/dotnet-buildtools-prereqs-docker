FROM library/gcc:15-trixie

ENV POWERSHELL_VERSION=7.6.0

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
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb -o /tmp/powershell.deb \
    && dpkg -i /tmp/powershell.deb || true \
    && apt-get update \
    && apt-get install -f -y \
    && rm -rf /tmp/powershell.deb /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8

# These symlinks are required because this docker has gcc-12 suffixed with version and gcc-15 unsuffixed in PATH.
# In the runtime repo, we (by design) give precedence to suffixed compilers before selecting unsuffixed one in PATH.
RUN ln -s $(command -v gcc) /usr/bin/gcc-15 \
    && ln -s $(command -v g++) /usr/bin/g++-15
