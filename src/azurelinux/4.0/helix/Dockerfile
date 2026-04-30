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

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot && \
    mkdir -p /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot
