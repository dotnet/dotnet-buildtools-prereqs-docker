FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net9.0-local AS builder
ARG ROOTFS_DIR=/crossrootfs/x64

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

RUN TARGET_TRIPLE="x86_64-linux-gnu" && \
    cmake -S llvm-project.src/runtimes -B runtimes \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_ASM_COMPILER=clang \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_ASM_COMPILER_TARGET="$TARGET_TRIPLE" \
        -DCMAKE_C_COMPILER_TARGET="$TARGET_TRIPLE" \
        -DCMAKE_CXX_COMPILER_TARGET="$TARGET_TRIPLE" \
        # We're going to link the static libraries we build here into PIC images, so build the static libraries as PIC.
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DCMAKE_SYSROOT="$ROOTFS_DIR" \
        # Specify linker to use for exes directly for CMake toolchain detection
        -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
        # Don't search for tools in the sysroot as we're cross-compiling
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="NEVER" \
        -DLLVM_USE_LINKER=lld \
        # We build libcxxabi here to get the cxxabi.h header file installed in libc++'s standard include directory.
        # Even though we aren't using libc++abi and we're using libstdc++ to provide the ABI, the header is identical as it
        # defines the methods provided by the Itanium ABI, which is shared by both libc++abi and libstdc++.
        -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi" \
        -DLIBCXX_ENABLE_SHARED=OFF \
        -DLIBCXX_CXX_ABI="libcxxabi" \
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
        -DLLVM_USE_SANITIZER="Address" \
        -DLIBCXXABI_ENABLE_SHARED=OFF \
        -DLIBCXXABI_USE_LLVM_UNWINDER=OFF \
        -DCOMPILER_RT_CXX_LIBRARY="libcxx" \
        -DCOMPILER_RT_STATIC_CXX_LIBRARY=ON \
        -DSANITIZER_CXX_ABI_LIBNAME="libc++" \ 
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        # Install Compiler-RT libraries and headers to the correct path in the final image here
        # as we use them to build the sanitized libcxxabi and libcxx
        -DCOMPILER_RT_INSTALL_PATH="/usr/local/lib/clang/cross" && \
    # Install the compiler-rt headers first so we can build a sanitized libcxxabi and libcxx
    cmake --install runtimes --component compiler-rt-headers && \
    cmake --build runtimes -j && \
    cmake --install runtimes --prefix "$ROOTFS_DIR/usr"

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-llvm-net9.0-local
ARG ROOTFS_DIR=/crossrootfs/x64

COPY --from=builder /usr/local/lib/clang/cross /usr/local/lib/clang/cross
COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR

# Compat with dotnet/runtime's current build: Copy the clang resources to our manually-specified resources dir in the crossrootfs.
ARG LLVM_VERSION_MAJOR=18

COPY --from=builder /usr/local/lib/clang/cross /usr/local/lib/clang/$LLVM_VERSION_MAJOR/
