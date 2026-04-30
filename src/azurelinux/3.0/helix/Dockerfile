FROM mcr.microsoft.com/azurelinux/base/core:3.0

# Install .NET and test dependencies
RUN tdnf install --setopt tsflags=nodocs --refresh -y \
        ca-certificates-microsoft \
        icu \
        iputils \
        libgcc-atomic \
        libmsquic \
        llvm \
        python3 \
        python3-pip \
        shadow-utils \
        sudo \
        tar \
        tzdata \
        which \
    && tdnf downgrade -y SymCrypt-OpenSSL-1.9.3 \
    && tdnf clean all

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot && \
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

# Install Helix Dependencies
