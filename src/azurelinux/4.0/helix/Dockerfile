FROM azlpubstagingacroxz2o4gw.azurecr.io/azurelinux/base/core:4.0

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
