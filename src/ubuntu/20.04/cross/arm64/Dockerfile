FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-crossdeps-local AS binutils

RUN echo "force rebuild"

# Install binutils-aarch64-linux-gnu
RUN apt-get update \
    && apt-get install -y \
        binutils-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*


FROM binutils AS rootfsbuild
ARG ROOTFS_DIR=/crossrootfs/arm64

# Build rootfs
RUN git config --global user.email builder@dotnet-buildtools-prereqs-docker && \
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts
RUN /scripts/eng/common/cross/build-rootfs.sh arm64 xenial lldb3.9 --skipunmount
RUN bash -c "rm -rf $ROOTFS_DIR/*/{var/cache/apt/archives/*,var/lib/apt/lists/*,usr/share/doc,usr/share/man}"

# Build llvm-9 compiler-rt profile library for arm64, for PGO support
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/compiler-rt-9.0.1.src.tar.xz
RUN tar -xf compiler-rt-9.0.1.src.tar.xz && \
    rm compiler-rt-9.0.1.src.tar.xz
RUN mkdir compiler-rt-build && \
    cd compiler-rt-build && \
    \
    TARGET_TRIPLE=aarch64-linux-gnu \
    BUILD_FLAGS="-v --sysroot=$ROOTFS_DIR" && \
    \
    cmake ../compiler-rt-9.0.1.src \
        -DCOMPILER_RT_BUILD_PROFILE=ON \
        -DCOMPILER_RT_BUILD_BUILTINS=OFF \
        -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
        -DCOMPILER_RT_BUILD_XRAY=OFF \
        -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
        \
        -DCMAKE_C_COMPILER=/usr/bin/clang-9 \
        -DCMAKE_CXX_COMPILER=/usr/bin/clang++-9 \
        -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
        -DCMAKE_C_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCMAKE_CXX_COMPILER_TARGET="${TARGET_TRIPLE}" \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
        -DLLVM_CONFIG_PATH=/usr/bin/llvm-config-9 \
        \
        -DCMAKE_C_FLAGS="${BUILD_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${BUILD_FLAGS}"

RUN cd compiler-rt-build && make

# Copy profile library to the rootfs
RUN mkdir -p $ROOTFS_DIR/usr/lib/llvm-9/lib/clang/9.0.1/lib/linux/ && \
    cp /compiler-rt-build/lib/linux/libclang_rt.profile-aarch64.a $ROOTFS_DIR/usr/lib/llvm-9/lib/clang/9.0.1/lib/linux/


FROM binutils
ARG ROOTFS_DIR=/crossrootfs/arm64
COPY --from=rootfsbuild $ROOTFS_DIR $ROOTFS_DIR
