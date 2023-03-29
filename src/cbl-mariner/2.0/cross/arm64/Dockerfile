FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm64

RUN /scripts/eng/common/cross/build-rootfs.sh arm64 xenial --skipunmount

# Build compiler-rt profile library for PGO instrumentation
RUN mkdir compiler-rt_build && cd compiler-rt_build && \
    BUILD_FLAGS="-v --sysroot=$ROOTFS_DIR" \
    TARGET_TRIPLE=aarch64-linux-gnu && \
    cmake ../llvm-project.src/compiler-rt \
        -DCOMPILER_RT_BUILD_PROFILE=ON \
        -DCOMPILER_RT_BUILD_BUILTINS=OFF \
        -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
        -DCOMPILER_RT_BUILD_XRAY=OFF \
        -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
        \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
        -DCMAKE_C_COMPILER_TARGET=${TARGET_TRIPLE} \
        -DCMAKE_CXX_COMPILER_TARGET=${TARGET_TRIPLE} \
        -DLLVM_CONFIG_PATH=llvm-config \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$ROOTFS_DIR/usr \
        -DCMAKE_C_FLAGS="${BUILD_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${BUILD_FLAGS}" && \
    make -j $(getconf _NPROCESSORS_ONLN)

RUN LLVM_VERSION=12.0.1 LLVM_VERSION_MAJOR="${LLVM_VERSION%%.*}" && \
    mkdir -p $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    cp compiler-rt_build/lib/linux/libclang_rt.profile-aarch64.a $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-arm-local
ARG ROOTFS_DIR=/crossrootfs/arm64

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
