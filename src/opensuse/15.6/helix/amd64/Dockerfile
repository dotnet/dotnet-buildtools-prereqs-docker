FROM opensuse/leap:15.6

# Install Helix Dependencies
RUN zypper ref \
    && zypper update -y \
    && zypper install -y -t pattern \
        devel_C_C++ \
    && zypper install -y \
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
        libicu-devel \
        libopenssl-devel \
        libtool \
        libunwind \
        lldb-devel \
        llvm \
        lttng-ust-devel \
        python312-devel \
        python312-pip \
        sudo \
        unzip \
        wget \
    && zypper clean -a

ENV LANG=en_US.utf8

# Install MsQuic from official GitHub releases
RUN wget https://packages.microsoft.com/keys/microsoft.asc \
    && echo 2cfd20a306b2fa5e25522d78f2ef50a1f429d35fd30bd983e2ebffc2b80944fa microsoft.asc | sha256sum --check - \
    && rpm --import microsoft.asc \
    && rm microsoft.asc \
    && zypper addrepo https://packages.microsoft.com/opensuse/15/prod/ "MS Packages" \
    && zypper install -y \
        libmsquic \
    && zypper clean -a

RUN ln -sf /usr/bin/python3.12 /usr/bin/python \
    && pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple \
    && pip install ./helix_scripts-*-py3-none-any.whl

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd --uid 1000 --shell /bin/bash --system --create-home --groups trusted helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m venv /home/helixbot/.vsts-env
