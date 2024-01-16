FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

# Install binutils-aarch64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.arm64.tar crossrootfs

# Remove older version of node & install node 20
RUN cd /etc/apt/sources.list.d  && \
    rm nodesource.list && \
    apt --fix-broken install && \
    apt update && \
    apt remove nodejs && \
    apt remove nodejs-doc
RUN cd ~ && \
    curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs -y && \
    rm -rf /var/lib/apt/lists/*