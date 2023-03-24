FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-crossdeps-local

# 1. Obtain signing keys used to sign llvm sources
RUN wget https://releases.llvm.org/release-keys.asc && \
    echo "f181a90697e3ea4b7782f1ee48314a570aef058505b4f3a0ab0611094ec13241 release-keys.asc" | sha256sum -c && \
    gpg --output release-keys.gpg --dearmor release-keys.asc && \
    rm release-keys.asc && \
# 2. Download llvm sources and signature, and verify signature
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-12.0.1.src.tar.xz.sig && \
    echo "6cc956d622a7d3d746de0d71d8ca616a6c291e2c561703ac7a9535f38b999955 llvm-project-12.0.1.src.tar.xz.sig" | sha256sum -c && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-12.0.1.src.tar.xz && \
    echo "129cb25cd13677aad951ce5c2deb0fe4afc1e9d98950f53b51bdcfb5a73afa0e llvm-project-12.0.1.src.tar.xz" | sha256sum -c && \
    gpg --keyring /release-keys.gpg --verify llvm-project-12.0.1.src.tar.xz.sig && \
    rm llvm-project-12.0.1.src.tar.xz.sig
