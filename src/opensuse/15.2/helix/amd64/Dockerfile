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
        wget \
        unzip && \
        \
        zypper clean -a

ENV LANG=en_US.utf8

RUN wget https://github.com/microsoft/msquic/releases/download/v2.1.1/libmsquic-2.1.1-1.x86_64.rpm && \
    rpm -i libmsquic-2.1.1-1.x86_64.rpm && \
    rm libmsquic-2.1.1-1.x86_64.rpm

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
