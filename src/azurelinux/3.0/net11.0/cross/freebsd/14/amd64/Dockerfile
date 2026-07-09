ARG ROOTFS_DIR=/crossrootfs/x64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

# Install packages needed by the FreeBSD bootstrap scripts
RUN tdnf install -y \
        automake \
        autoconf \
        awk \
        libtool \
        m4 && \
    # The xz package in Azure Linux 3.0 doesn't provide liblzma.so, so we need to create a symlink to liblzma.so.5
    # so the FreeBSD bootstrap can find it. See https://github.com/microsoft/azurelinux/issues/9217
    ln -s /usr/lib/liblzma.so.5 /usr/lib/liblzma.so

RUN wget -qO- "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4F3E74F436050C10F5696574B972BF3EA4AE57A3" | \
        gpg --batch --import && \
    echo "4F3E74F436050C10F5696574B972BF3EA4AE57A3:6:" | gpg --import-ownertrust

RUN cd /tmp && wget -O libmd-1.2.0.tar.xz "https://libbsd.freedesktop.org/releases/libmd-1.2.0.tar.xz" && \
    wget -O libmd-1.2.0.tar.xz.asc "https://libbsd.freedesktop.org/releases/libmd-1.2.0.tar.xz.asc" && \
    gpg --batch --verify libmd-1.2.0.tar.xz.asc libmd-1.2.0.tar.xz && \
    mkdir libmd && tar -xJf libmd-1.2.0.tar.xz -C libmd --strip-components=1 && \
    cd libmd && ./configure && make -j install

RUN cd /tmp && wget -O libbsd-0.12.2.tar.xz "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz" && \
    wget -O libbsd-0.12.2.tar.xz.asc "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz.asc" && \
    gpg --batch --verify libbsd-0.12.2.tar.xz.asc libbsd-0.12.2.tar.xz && \
    mkdir libbsd && tar -xJf libbsd-0.12.2.tar.xz -C libbsd --strip-components=1 && \
    cd libbsd && ./configure && make -j install

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf && ldconfig

RUN /scripts/eng/common/cross/build-rootfs.sh freebsd14 x64 --ubuntu-repo "http://azure.archive.ubuntu.com/ubuntu/"

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder "$ROOTFS_DIR" "$ROOTFS_DIR"
