FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net9.0-local AS builder
ARG ROOTFS_DIR=/crossrootfs/arm

RUN /scripts/eng/common/cross/build-rootfs.sh arm xenial --skipunmount

ARG TARGET_TRIPLE="arm-linux-gnueabihf"

RUN cmake -S llvm-project.src/runtimes -B runtimes \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_ASM_COMPILER=clang \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_ASM_COMPILER_TARGET="$TARGET_TRIPLE" \
        -DCMAKE_C_COMPILER_TARGET="$TARGET_TRIPLE" \
        -DCMAKE_CXX_COMPILER_TARGET="$TARGET_TRIPLE" \
        -DCMAKE_SYSROOT="$ROOTFS_DIR" \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DLLVM_USE_LINKER=lld \
        # We build libcxxabi here to get the cxxabi.h header file installed in libc++'s standard include directory.
        # Even though we aren't using libc++abi and we're using libstdc++ to provide the ABI, the header is identical as it
        # defines the methods provided by the Itanium ABI, which is shared by both libc++abi and libstdc++.
        -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;compiler-rt" \
        -DLIBCXX_ENABLE_SHARED=OFF \
        -DLIBCXXABI_ENABLE_SHARED=OFF \
        -DLIBCXXABI_USE_LLVM_UNWINDER=OFF \
        -DLIBCXX_CXX_ABI=libstdc++ \
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$ROOTFS_DIR/usr/include/c++/5.4.0/;$ROOTFS_DIR/usr/include/$TARGET_TRIPLE" \
        -DCOMPILER_RT_CXX_LIBRARY="libcxx" \
        -DCOMPILER_RT_STATIC_CXX_LIBRARY=ON \
        -DSANITIZER_CXX_ABI_LIBNAME="libstdc++" \ 
        -DCOMPILER_RT_INSTALL_PATH="/cross-libs/" && \
    cmake --build runtimes -j $(getconf _NPROCESSORS_ONLN) && \
    cmake --install runtimes --prefix "$ROOTFS_DIR/usr"

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net9.0-local
ARG ROOTFS_DIR=/crossrootfs/arm

COPY --from=builder /cross-libs/ /usr/local/lib/clang/cross
COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR

# Compat with dotnet/runtime's current build: Copy the clang resources to our manually-specified resources dir in the crossrootfs.
ARG LLVM_VERSION_MAJOR=18

COPY --from=builder /cross-libs /usr/local/lib/clang/$LLVM_VERSION_MAJOR/
