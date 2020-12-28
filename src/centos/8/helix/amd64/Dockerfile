FROM centos:8

# Install dependencies
RUN dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
        epel-release \
    && \
    dnf config-manager --set-enabled powertools \
    && \
    dnf install --setopt tsflags=nodocs -y \
        gcc \
        libicu \
        openssl \
        python3 \
        python3-devel \
        sudo \
        tar \
        wget \
        which \
    && \
    dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

ENV LANG en_US.utf8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
