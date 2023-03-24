FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-arm-local
ARG ROOTFS_DIR=/crossrootfs/arm

RUN tdnf install -y debootstrap

RUN /scripts/eng/common/cross/build-rootfs.sh arm xenial --skipunmount

# Build compiler-rt profile library for PGO instrumentation
COPY --from=mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-artifacts-local \
    /llvm-project-12.0.1.src.tar.xz .
RUN tar -xf llvm-project-12.0.1.src.tar.xz && \
    rm llvm-project-12.0.1.src.tar.xz && \
    mkdir compiler-rt_build && cd compiler-rt_build && \
    BUILD_FLAGS="-v --sysroot=$ROOTFS_DIR" \
    TARGET_TRIPLE=arm-linux-gnueabihf && \
    cmake ../llvm-project-12.0.1.src/compiler-rt \
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
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

RUN mkdir -p $ROOTFS_DIR/usr/lib/llvm-12/lib/clang/12.0.1/lib/linux/ && \
    cp ./compiler-rt_build/lib/linux/libclang_rt.profile-armhf.a $ROOTFS_DIR/usr/lib/llvm-12/lib/clang/12.0.1/lib/linux/

RUN rm -r compiler-rt_build llvm-project-12.0.1.src
