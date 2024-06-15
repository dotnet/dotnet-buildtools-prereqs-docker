FROM mcr.microsoft.com/dotnet-buildtools/prereqs:centos-7-mlnet-local

RUN yum install -y \
        dnf

# Install dependencies
RUN curl -LO https://packages.microsoft.com/keys/microsoft.asc && \
    echo 2cfd20a306b2fa5e25522d78f2ef50a1f429d35fd30bd983e2ebffc2b80944fa microsoft.asc| sha256sum --check - && \
    rpm --import microsoft.asc && \
    rm microsoft.asc && \
    dnf install --setopt tsflags=nodocs --refresh -y \
        dnf-plugins-core \
        epel-release \
    && \
    dnf config-manager --add-repo https://packages.microsoft.com/centos/7/prod \
    && \
    dnf install --setopt tsflags=nodocs -y \
        gcc \
        libicu \
        libmsquic \
        openssl \
        openssl11-libs \
        python3 \
        python3-devel \
        sudo \
        tar \
        wget \
        which \
    && \
    dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

ENV LANG=en_US.utf8

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --gid adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
