ARG ROOTFS_DIR=/crossrootfs/x64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

# Build compiler-rt profile library for PGO instrumentation
RUN mkdir compiler-rt_build && cd compiler-rt_build && \
    BUILD_FLAGS="-v --sysroot=$ROOTFS_DIR" \
    TARGET_TRIPLE="x86_64-linux-gnu" && \
    cmake ../llvm-project.src/compiler-rt \
        -DCOMPILER_RT_BUILD_PROFILE=ON \
        -DCOMPILER_RT_BUILD_SANITIZERS=ON \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        \
        -DCOMPILER_RT_BUILD_BUILTINS=OFF \
        -DCOMPILER_RT_BUILD_CRT=OFF \
        -DCOMPILER_RT_BUILD_GWP_ASAN=OFF \
        -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
        -DCOMPILER_RT_BUILD_MEMPROF=OFF \
        -DCOMPILER_RT_BUILD_ORC=OFF \
        -DCOMPILER_RT_BUILD_XRAY=OFF \
        \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_ASM_COMPILER=clang \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_SHARED_LINKER_FLAGS="-fuse-ld=lld" \
        -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
        -DCMAKE_ASM_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_C_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_CXX_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_ASM_FLAGS="${BUILD_FLAGS}" \
        -DCMAKE_C_FLAGS="${BUILD_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${BUILD_FLAGS}" && \
    make -j $(getconf _NPROCESSORS_ONLN)

RUN LLVM_VERSION=16.0.6 LLVM_VERSION_MAJOR="${LLVM_VERSION%%.*}" SANITIZER_RUNTIMES_DIR=/sanitizer-runtimes && \
    mkdir -p $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    cp compiler-rt_build/lib/linux/libclang_rt.profile-x86_64.a $ROOTFS_DIR/usr/lib/llvm-${LLVM_VERSION_MAJOR}/lib/clang/${LLVM_VERSION}/lib/linux/ && \
    mkdir ${SANITIZER_RUNTIMES_DIR} && \
    cp compiler-rt_build/lib/linux/libclang_rt.*-x86_64.a $SANITIZER_RUNTIMES_DIR


FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR
ARG LLVM_VERSION_MAJOR=16

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
COPY --from=builder /sanitizer-runtimes /usr/local/lib/clang/$LLVM_VERSION_MAJOR/lib/linux/
COPY --from=builder compiler-rt_build/include/sanitizer /usr/local/lib/clang/$LLVM_VERSION_MAJOR/include/sanitizer/
