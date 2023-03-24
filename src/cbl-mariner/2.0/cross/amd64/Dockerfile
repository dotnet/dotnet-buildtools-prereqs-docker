FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-amd64-local
ARG ROOTFS_DIR=/crossrootfs/x64

RUN tdnf install -y debootstrap

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

RUN mkdir -p $ROOTFS_DIR/usr/lib/llvm-12/lib/clang/12.0.1/lib/linux/ && \
    cp /usr/lib/clang/12.0.1/lib/linux/libclang_rt.profile-x86_64.a $ROOTFS_DIR/usr/lib/llvm-12/lib/clang/12.0.1/lib/linux/