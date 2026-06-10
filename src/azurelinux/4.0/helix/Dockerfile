FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0 AS venv

RUN dnf install --refresh -y \
    ca-certificates \
    iputils \
    python3 \
    python3-devel \
    python3-pip

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
        pip install ./helix_scripts-*-py3-none-any.whl --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
        rm ./helix_scripts-*-py3-none-any.whl

FROM mcr.microsoft.com/azurelinux-beta/base/core:4.0

# Install .NET and test dependencies
RUN dnf install --setopt tsflags=nodocs --refresh -y \
        ca-certificates \
        icu \
        iputils \
        libatomic \
        llvm \
        python3 \
        python3-pip \
        shadow-utils \
        sudo \
        tar \
        tzdata \
        which \
    && dnf clean all

# Install msquic from previous AZL realese until azurelinux-official-ms-oss is available
COPY azl3-repomd.xml.key /tmp/azl3-repomd.xml.key

RUN tdnf update -y && \
    tdnf install numactl-libs libxdp libnl3 --setopt tsflags=nodocs --refresh -y \
    && tdnf --repoid azl3 '--repofrompath=azl3,https://packages.microsoft.com/azurelinux/3.0/prod/ms-oss/$basearch' --setopt='azl3.gpgkey=file:///tmp/azl3-repomd.xml.key' --setopt=azl3.gpgcheck=1 --setopt=azl3.repo_gpgcheck=1 install -y libmsquic \
    && tdnf clean all \
    && rm -f /tmp/azl3-repomd.xml.key

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot && \
    mkdir -p /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
