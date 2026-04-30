FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

# Install Helix Dependencies

ENV LANG=en_US.utf8

RUN tdnf install --setopt tsflags=nodocs --refresh -y \
         ca-certificates-microsoft \
         gcc \
         icu \
         iputils \
         libmsquic \
         llvm \
         python3-pip \
         shadow-utils \
         sudo \
         tar \
         tzdata \
         which \
    && tdnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot && \
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot
WORKDIR /home/helixbot
