FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-builder-local AS builder
ARG ROOTFS_DIR=/crossrootfs/x64

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount


# Build compiler-rt profile library for PGO instrumentation
RUN mkdir compiler-rt_build && cd compiler-rt_build && \
    cmake ../llvm-project.src/compiler-rt \
        -DCOMPILER_RT_BUILD_PROFILE=ON \
        -DCOMPILER_RT_BUILD_BUILTINS=OFF \
        -DCOMPILER_RT_BUILD_CRT=OFF \
        -DCOMPILER_RT_BUILD_MEMPROF=OFF \
        -DCOMPILER_RT_BUILD_GWP_ASAN=OFF \
        -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
        -DCOMPILER_RT_BUILD_XRAY=OFF \
        -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
        -DCOMPILER_RT_BUILD_ORC=OFF \
        \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
        -DCMAKE_C_COMPILER_TARGET="x86_64-linux-gnu" \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_FLAGS="-v --sysroot=$ROOTFS_DIR" && \
    make -j $(getconf _NPROCESSORS_ONLN)

RUN LLVM_VERSION=16.0.0 LLVM_VERSION_MAJOR="${LLVM_VERSION%%.*}" && \
    mkdir -p $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    cp compiler-rt_build/lib/linux/libclang_rt.profile-x86_64.a $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    cp -r compiler-rt_build/include/sanitizer $ROOTFS_DIR/usr/include


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-llvm-local
ARG ROOTFS_DIR=/crossrootfs/x64

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
