FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net8.0 AS builder
ARG ROOTFS_DIR=/crossrootfs/x64

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

RUN mkdir libcxx && cd libcxx && \
    TARGET_TRIPLE="x86_64-linux-gnu" && \
    cmake ../llvm-project.src/runtimes \
        -DCMAKE_INSTALL_PREFIX="$ROOTFS_DIR/usr" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_ASM_COMPILER=clang \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_ASM_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_C_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_CXX_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_SYSROOT="$ROOTFS_DIR" \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DLLVM_USE_LINKER=lld \
# We build libcxxabi here to get the cxxabi.h header file installed in libc++'s standard include directory.
# Even though we aren't using libc++abi and we're using libstdc++ to provide the ABI, the header is identical as it
# defines the methods provided by the Itanium ABI, which is shared by both libc++abi and libstdc++.
        -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
        -DLIBCXX_ENABLE_SHARED=OFF \
        -DLIBCXXABI_ENABLE_SHARED=OFF \
        -DLIBCXXABI_USE_LLVM_UNWINDER=OFF \
        -DLIBCXX_CXX_ABI=libstdc++ \
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$ROOTFS_DIR/usr/include/c++/5.4.0/;$ROOTFS_DIR/usr/include/x86_64-linux-gnu" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net8.0
ARG ROOTFS_DIR=/crossrootfs/x64

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
COPY --from=builder /usr/local /usr/local