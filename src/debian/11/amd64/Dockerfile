FROM debian:11

# Dependencies for generic .NET Core builds and the base toolchain we need to
# build anything (clang, cmake, make and the like)
RUN apt-get update \
    && apt-get install -y \
            autoconf \
            automake \
            build-essential \
            clang \
            cmake \
            curl \
            g++ \
            gettext \
            gdb \
            git \
            gnupg \
            jq \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblldb-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl-dev \
            libssl1.1 \
            libtool \
            libunwind8-dev \
            lldb \
            llvm \
            locales \
            make \
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
