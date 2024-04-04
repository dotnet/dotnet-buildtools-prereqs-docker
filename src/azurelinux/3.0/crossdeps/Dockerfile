FROM azurelinuxpreview.azurecr.io/public/azurelinux/base/core:3.0

RUN tdnf update -y && \
    tdnf install -y \
        # Provides 'su', required by Azure DevOps
        ca-certificates \
        git \
        sudo \
        util-linux \
        wget \
        # Common runtime build dependencies
        awk \
        cmake \
        diffutils \
        icu \
        tar \
        zlib-devel \
        # Crosscomponents build dependencies
        glibc-devel \
        kernel-headers \
        lttng-ust-devel \
        # Jit rolling build dependency
        python3-pip \
        # diagnostics build dependency
        lldb-devel \
        # aspnetcore build dependencies
        nodejs
