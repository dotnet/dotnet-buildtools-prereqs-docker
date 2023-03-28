FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-artifacts-local as artifacts

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-local

# Install LLVM-only build dependencies
RUN tdnf install -y \
    texinfo \
    diffutils \
    binutils

# Build LLVM cross-toolchain (with support for targeting arm architectures)
COPY --from=artifacts /llvm-project.src.tar.xz .
RUN mkdir llvm-project.src && \
    tar -xf llvm-project.src.tar.xz --directory llvm-project.src --strip-components=1 && \
    rm llvm-project.src.tar.xz && \
    mkdir build && cd build && \
    cmake ../llvm-project.src/llvm \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="host;AArch64;ARM" \
        -Wno-dev \
        -DLLVM_ENABLE_PROJECTS="clang;lld" && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install

RUN rm -r build llvm-project.src

RUN tdnf remove -y \
    texinfo \
    diffutils \
    binutils
