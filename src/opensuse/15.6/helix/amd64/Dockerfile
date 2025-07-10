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
    && rpm --import microsoft.asc \
    && rm microsoft.asc \
    && zypper addrepo https://packages.microsoft.com/opensuse/15/prod/ "MS Packages" \
    && zypper install -y \
        libmsquic \
    && zypper clean -a

RUN ln -sf /usr/bin/python3.12 /usr/bin/python

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd --uid 1000 --shell /bin/bash --system --create-home --groups trusted helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot
WORKDIR /home/helixbot
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

RUN python -m venv $VIRTUAL_ENV && \
    ${VIRTUAL_ENV}/bin/pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    ${VIRTUAL_ENV}/bin/pip install ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
