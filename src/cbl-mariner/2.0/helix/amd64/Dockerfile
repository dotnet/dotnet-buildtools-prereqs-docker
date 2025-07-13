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
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

RUN python -m venv $VIRTUAL_ENV && \
    ${VIRTUAL_ENV}/bin/pip install --upgrade pip setuptools && \
    ${VIRTUAL_ENV}/bin/pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    ${VIRTUAL_ENV}/bin/pip install --upgrade pip && \
    ${VIRTUAL_ENV}/bin/pip install ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
