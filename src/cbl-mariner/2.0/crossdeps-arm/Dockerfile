FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-local

# Install LLVM-only build dependencies
RUN tdnf install -y \
    texinfo \
    diffutils \
    binutils

# Build LLVM cross-toolchain (with support for targeting arm architectures)
COPY --from=mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-artifacts-local \
    /llvm-project-12.0.1.src.tar.xz .
RUN tar -xf llvm-project-12.0.1.src.tar.xz && \
    rm llvm-project-12.0.1.src.tar.xz && \
    mkdir build && cd build && \
    cmake ../llvm-project-12.0.1.src/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="host;AArch64;ARM" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

RUN rm -r build llvm-project-12.0.1.src

RUN tdnf remove -y \
    texinfo \
    diffutils \
    binutils