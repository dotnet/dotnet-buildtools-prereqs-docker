FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-amd64-local
ARG ROOTFS_DIR=/crossrootfs/x64

RUN tdnf install -y debootstrap

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

RUN LLVM_VERSION=12.0.1 LLVM_VERSION_MAJOR="${LLVM_VERSION%%.*}" && \
    mkdir -p $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    cp /usr/lib/clang/${LLVM_VERSION}/lib/linux/libclang_rt.profile-x86_64.a $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/
