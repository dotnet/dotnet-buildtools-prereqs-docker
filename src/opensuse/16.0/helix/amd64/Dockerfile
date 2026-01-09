FROM opensuse/leap:16.0

# Install Helix Dependencies
RUN zypper ref \
    && zypper update -y \
    && zypper install -y \
        wget \
    && wget https://packages.microsoft.com/config/opensuse/16/prod.repo \
    && mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo \
    && chown root:root /etc/zypp/repos.d/microsoft-prod.repo \
    && zypper --gpg-auto-import-keys refresh \
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
        libmsquic \
        libopenssl-devel \
        libtool \
        libunwind8 \
        lldb-devel \
        llvm \
        lttng-ust-devel \
        python313-devel \
        python313-pip \
        sudo \
        unzip \
    && zypper clean -a

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3.13 /usr/bin/python

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
