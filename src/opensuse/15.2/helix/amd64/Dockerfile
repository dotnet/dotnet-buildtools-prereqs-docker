FROM opensuse/leap:15.2

# Install Helix Dependencies

RUN zypper ref && \
    zypper install -y -t pattern devel_C_C++ && \
    zypper install -y \
        autoconf \
        automake \
        clang \
        cmake \
        gcc-locale \
        gdb \
        git \
        glibc-i18ndata \
        gssntlmssp \
        iputils \
        krb5-devel \
        lato-fonts \
        libffi-devel \
        libgdiplus-devel \
        libicu-devel \
        libopenssl-devel \
        libtool \
        libunwind \
        lldb-devel \
        lttng-ust-devel \
        python3-devel \
        python3-pip \
        sudo \
        unzip \
        wget && \
        \
        zypper clean -a

ENV LANG=en_US.utf8

# Install MsQuic from official GitHub releases
RUN wget https://packages.microsoft.com/keys/microsoft.asc && \
    echo 2cfd20a306b2fa5e25522d78f2ef50a1f429d35fd30bd983e2ebffc2b80944fa microsoft.asc | sha256sum --check - && \
    rpm --import microsoft.asc && \
    rm microsoft.asc && \
    zypper install -y https://github.com/microsoft/msquic/releases/download/v2.1.1/libmsquic-2.1.1-1.x86_64.rpm && \
    zypper clean -a

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd --uid 1000 --shell /bin/bash --system --create-home --groups trusted helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
