FROM azlpubstagingacroxz2o4gw.azurecr.io/azurelinux/base/core:4.0 AS venv

RUN tdnf install --refresh -y \
    ca-certificates \
    iputils \
    python3 \
    python3-devel \
    python3-pip

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
        pip install ./helix_scripts-*-py3-none-any.whl && \
        rm ./helix_scripts-*-py3-none-any.whl

FROM azlpubstagingacroxz2o4gw.azurecr.io/azurelinux/base/core:4.0

# Install .NET and test dependencies
RUN tdnf install --setopt tsflags=nodocs --refresh -y \
        ca-certificates \
        icu \
        iputils \
        libatomic \
        llvm \
        python3 \
        python3-pip \
        shadow-utils \
        sudo \
        tar \
        tzdata \
        which \
    && tdnf clean all

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot && \
    mkdir -p /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
