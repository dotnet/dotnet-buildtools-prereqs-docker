FROM mcr.microsoft.com/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Common dependencies
        ca-certificates \
        git \
        shadow-utils \
        tar \
        util-linux \
        wget \
        # Runtime dependencies
        icu \
        # Optimization dependencies (provides llvm-profdata)
        llvm
