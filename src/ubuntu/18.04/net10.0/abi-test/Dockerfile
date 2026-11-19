FROM ubuntu.azurecr.io/ubuntu:18.04

# Test already-built native artifacts against glibc 2.27, not Ubuntu product support.
# Keep this runtime-only: no SDK, compiler, or compatibility sysroot.
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://azure.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        libc6 \
        libgcc1 \
        libicu60 \
        libssl1.1 \
        libstdc++6 \
        tzdata \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*
