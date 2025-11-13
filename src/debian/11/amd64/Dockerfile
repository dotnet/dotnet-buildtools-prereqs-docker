FROM library/debian:bullseye

# Dependencies for generic .NET Core builds and the base toolchain we need to
# build anything (clang, cmake, make and the like)
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
        software-properties-common \
    && curl -sL https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        azure-cli \
        build-essential \
        clang \
        cmake \
        elfutils \
        file \
        g++ \
        gettext \
        gdb \
        git \
        gnupg \
        jq \
        libcurl4-openssl-dev \
        libicu-dev \
        libkrb5-dev \
        liblldb-dev \
        liblttng-ust-dev \
        libssl-dev \
        libssl1.1 \
        libtool \
        libunwind8-dev \
        lldb \
        llvm \
        locales \
        make \
        pigz \
        powershell \
        python-lldb \
        sudo \
        tar \
        uuid-dev \
        zip \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
# These commands are from https://askubuntu.com/a/1027038
RUN echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections \
    && echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections \
    && rm "/etc/locale.gen" \
    && dpkg-reconfigure --frontend noninteractive locales
