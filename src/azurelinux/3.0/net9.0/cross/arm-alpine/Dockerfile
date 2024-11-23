ARG ROOTFS_DIR=/crossrootfs/arm

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh arm alpine3.13 --skipunmount

RUN TARGET_TRIPLE="armv7-alpine-linux-musleabihf" && \
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
        -DLLVM_ENABLE_RUNTIMES="libcxx" \
        -DLIBCXX_ENABLE_SHARED=OFF \
        -DLIBCXX_HAS_MUSL_LIBC=ON \
        -DLIBCXX_CXX_ABI=libstdc++ \
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$ROOTFS_DIR/usr/include/c++/10.2.1/;$ROOTFS_DIR/usr/include/c++/10.2.1/$TARGET_TRIPLE" && \
    cmake --build runtimes -j $(getconf _NPROCESSORS_ONLN) && \
    cmake --install runtimes --prefix "$ROOTFS_DIR/usr"

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
