FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-stream8-local

USER root

RUN dnf install --setopt tsflags=nodocs -y \
    cmake \
    clang

# Install openmp from llvm 3.9.1.
RUN wget http://releases.llvm.org/3.9.1/openmp-3.9.1.src.tar.xz && \
    mkdir -p llvm-3.9.1.src/openmp && \
    tar -xf openmp-3.9.1.src.tar.xz --strip 1 -C llvm-3.9.1.src/openmp && \
    rm -f openmp-3.9.1.src.tar.xz && \
    \
    mkdir llvmbuild && \
    cd llvmbuild && \
    cmake \
        -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
        -DCMAKE_C_COMPILER=/usr/bin/clang \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_LIBDIR_SUFFIX=64\
        -DLLVM_ENABLE_EH=1 \
        -DLLVM_ENABLE_RTTI=1 \
        ../llvm-3.9.1.src/openmp \
     && \
     make -j $(($(getconf _NPROCESSORS_ONLN)+1)) && \
     make install && \
     cd .. && \
     rm -f -r llvmbuild && \
     rm -f -r llvm-3.9.1.src

# Sets the library path to pickup openmp
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
