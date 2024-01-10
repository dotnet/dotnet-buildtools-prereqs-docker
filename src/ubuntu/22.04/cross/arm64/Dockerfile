FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-crossdeps-local

# Install binutils-aarch64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs.arm64.tar crossrootfs

# update node
ENV NODE_VERSION 20.9.0
RUN cd ~ && \
    curl -LO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.xz && \
    tar xf node-v${NODE_VERSION}-linux-arm64.tar.xz