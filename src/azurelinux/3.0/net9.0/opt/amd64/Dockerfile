FROM azurelinuxpreview.azurecr.io/public/azurelinux/base/core:3.0

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
        llvm
