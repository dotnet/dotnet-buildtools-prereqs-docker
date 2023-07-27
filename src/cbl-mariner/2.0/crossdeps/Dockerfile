FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf update -y && \
    tdnf install -y \

        # Provides 'su', required by Azure DevOps
        ca-certificates \
        git \
        util-linux \
        wget \
        sudo \

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
        python3-pip
