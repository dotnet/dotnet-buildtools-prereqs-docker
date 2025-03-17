ARG ROOTFS_DIR=/crossrootfs/x64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-builder-amd64 AS builder
ARG ROOTFS_DIR

RUN /scripts/eng/common/cross/build-rootfs.sh x64 xenial --skipunmount

RUN TARGET_TRIPLE="x86_64-linux-gnu" && \
    GCC_VER=$(basename "$(find "$ROOTFS_DIR/usr/include/c++/" -mindepth 1 -maxdepth 1 -type d | sort -V | head -n1)") && \
    CPP_INCLUDES="$ROOTFS_DIR/usr/include/c++/$GCC_VER" && \
    TRIPLET_INCLUDES=$([ -e "$CPP_INCLUDES/$TARGET_TRIPLE" ] && echo "$CPP_INCLUDES/$TARGET_TRIPLE" || echo "$(realpath "$CPP_INCLUDES/../../$TARGET_TRIPLE");$(realpath "$CPP_INCLUDES/../../$TARGET_TRIPLE/c++/$GCC_VER")") && \
    echo "Using C++ includes $CPP_INCLUDES and $TRIPLET_INCLUDES to build for $TARGET_TRIPLE" && \
    CLANG_MAJOR_VERSION=$(clang --version | grep -oP "(?<=version )\d+") && \
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
        -DLLVM_ENABLE_RUNTIMES="libcxx;compiler-rt" \
        -DLIBCXX_ENABLE_SHARED=OFF \
        -DLIBCXX_CXX_ABI=libstdc++ \
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$CPP_INCLUDES;$TRIPLET_INCLUDES" \
        -DCOMPILER_RT_CXX_LIBRARY="libcxx" \
        -DCOMPILER_RT_STATIC_CXX_LIBRARY=ON \
        -DCOMPILER_RT_BUILD_SANITIZERS=OFF \ 
        -DCOMPILER_RT_BUILD_MEMPROF=OFF \
        # The libfuzzer build in LLVM doesn't correctly forward the required CMake properties to the "fuzzed libc++" build
        # so skip it here.
        -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        -DCOMPILER_RT_INSTALL_PATH="/usr/local/lib/clang/$CLANG_MAJOR_VERSION" && \
    cmake --build runtimes -j $(getconf _NPROCESSORS_ONLN) && \
    cmake --install runtimes --prefix "$ROOTFS_DIR/usr"

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-llvm-amd64
ARG ROOTFS_DIR

COPY --from=builder /usr/local/lib/clang /usr/local/lib/clang/
COPY --from=builder $ROOTFS_DIR $ROOTFS_DIR
