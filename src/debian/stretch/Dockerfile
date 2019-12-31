FROM debian:stretch

# Dependencies for generic .NET Core builds and the base toolchain we need to 
# build anything (clang, cmake, make and the like)
RUN apt-get update \
    && apt-get install -y \
            clang \
            cmake \
            curl \
            g++ \
            gettext \
            gdb \
            git \
            gnupg \
            libcurl4-openssl-dev \
            libgdiplus \
            libicu-dev \
            libkrb5-dev \
            liblldb-3.9-dev \
            liblttng-ust-dev \
            libnuma-dev \
            libssl1.0-dev \
            libssl1.0.2 \
            libunwind8-dev \
            lldb-3.9 \
            llvm \
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
    && apt-get install -y nodejs

# Install Azure CLI
RUN apt-get update \
    && apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install azure-cli \
    && rm -rf /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && rm -rf /etc/apt/sources.list.d/azure-cli.list \
    && rm -rf /var/lib/apt/lists/*

# Until official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64
