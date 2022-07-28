FROM debian:stretch

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
            liblldb-3.9-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl1.0-dev \
            libssl1.0.2 \
            libtool \
            libunwind8-dev \
            lldb-3.9 \
            llvm \
            locales \
            make \
            python-lldb-3.9 \
            sudo \
            tar \
            uuid-dev \
            zip \
            zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install tools used by the VSO build automation.
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g azure-cli --unsafe-perm

# .NET SDK MSBuild requires US.UTF-8 locale to execute tasks
# These commands are from https://askubuntu.com/a/1027038
RUN echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections \
    && echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections \
    && rm "/etc/locale.gen" \
    && dpkg-reconfigure --frontend noninteractive locales

# Until official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64
