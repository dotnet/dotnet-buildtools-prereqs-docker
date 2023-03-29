FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf update -y && \
    tdnf install -y \
        wget \
        ca-certificates \
        git \
        # Common runtime build dependencies
        cmake \
        awk \
        icu \
        tar \
        # Crosscomponents build dependencies
        glibc-devel \
        lttng-ust-devel \
        kernel-headers
