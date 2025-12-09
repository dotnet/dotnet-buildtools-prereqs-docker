FROM opensuse/leap:16.0
# Using RC version from testing feed as it has correct dependencies (libcrypto.so.3)
# The production feed versions depend on libcrypto.so.1.1 which is incompatible
ARG LIBMSQUIC_VERSION=2.4.17~rc2

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
        libunwind8 \
        lldb-devel \
        llvm \
        lttng-ust-devel \
        python313-devel \
        python313-pip \
        sudo \
        unzip \
        wget \
    && zypper clean -a

ENV LANG=en_US.utf8

# Install MsQuic from official GitHub releases
# Using opensuse15 testing feed as it's compatible with openSUSE 16.0
# See: https://github.com/microsoft/msquic/issues/5567#issuecomment-3618761370
RUN wget https://packages.microsoft.com/keys/microsoft.asc \
    && rpm --import microsoft.asc \
    && rm microsoft.asc \
    && wget "https://packages.microsoft.com/yumrepos/microsoft-opensuse15-testing-prod/Packages/l/libmsquic-${LIBMSQUIC_VERSION}-1.x86_64.rpm" \
    && rpm -i libmsquic-${LIBMSQUIC_VERSION}-1.x86_64.rpm \
    && rm libmsquic-${LIBMSQUIC_VERSION}-1.x86_64.rpm

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
