FROM library/gcc:13-bookworm

# Dependencies for dotnet/runtime native components.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
    && curl -sL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
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
        pigz \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# These symlinks are required to provide gcc-13 and g++-13 in PATH.
# In the runtime repo, we (by design) give precedence to suffixed compilers before selecting unsuffixed one in PATH.
RUN test -e /usr/bin/gcc-13 || ln -s $(command -v gcc) /usr/bin/gcc-13 \
    && test -e /usr/bin/g++-13 || ln -s $(command -v g++) /usr/bin/g++-13
