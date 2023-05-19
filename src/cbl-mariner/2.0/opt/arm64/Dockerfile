FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf update -y && \
    tdnf install -y \
        # Common dependencies
        ca-certificates \
        git \
        tar \
        util-linux \
        wget \
        # Runtime dependencies
        icu \
        # Optimization dependencies (provides llvm-profdata)
        llvm16
