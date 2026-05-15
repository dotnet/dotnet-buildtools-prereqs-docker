ARG ROOTFS_DIR=/crossrootfs/s390x

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN rootfsEnv="/usr/local/share/rootfs" && \
    python3 -m venv "$rootfsEnv" && \
    "$rootfsEnv/bin/python" -m pip install aiohttp zstandard && \
    PYTHON_EXECUTABLE="$rootfsEnv/bin/python" /scripts/eng/common/cross/build-rootfs.sh bionic s390x --skipunmount --skipemulation

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
