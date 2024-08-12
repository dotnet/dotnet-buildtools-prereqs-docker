FROM mcr.microsoft.com/azurelinux/base/core:3.0 as msquic
ARG TARGETARCH

ENV LANG=en_US.utf8

# build MsQuic as we don't have packages
RUN tdnf install --refresh -y \
        ca-certificates-microsoft \
        cmake \
        gcc-c++ \
        gcc \
        git \
        libnuma-devel \
        kernel-headers \
        lttng-ust-devel \
        make \
        openssl-devel \
        perl

RUN git clone --depth 1 --single-branch --branch v2.4.1 --recursive https://github.com/microsoft/msquic /tmp/msquic

WORKDIR /tmp/msquic

RUN cmake -B build/linux/Release_openssl3 \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_TARGET_ARCHITECTURE=${TARGETARCH} \
       -DQUIC_TLS=openssl3 \
       -DQUIC_ENABLE_LOGGING=true \
       -DQUIC_USE_SYSTEM_LIBCRYPTO=true \
       -DQUIC_BUILD_TOOLS=off \
       -DQUIC_BUILD_TEST=off \
       -DQUIC_BUILD_PERF=off && \
    cmake --build build/linux/Release_openssl3  --config Release && \
    cmake --install build/linux/Release_openssl3 --prefix /msquic

FROM msquic as venv

RUN tdnf install --refresh -y \
    build-essential \
    ca-certificates-microsoft \
    gcc \
    iputils \
    python3-devel \
    python3-pip

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
        pip install ./helix_scripts-*-py3-none-any.whl


FROM mcr.microsoft.com/azurelinux/base/core:3.0

# Install .NET and test dependencies
RUN tdnf install --setopt tsflags=nodocs --refresh -y \
        ca-certificates-microsoft \
        icu \
        iputils \
        llvm \
        shadow-utils \
        tar \
        tzdata \
        which \
    && tdnf clean all


# Copy msquic from the msquic image into our image that will run on Helix
COPY --from=msquic /msquic /usr

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=venv /venv $VIRTUAL_ENV
