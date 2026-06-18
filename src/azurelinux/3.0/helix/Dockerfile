FROM mcr.microsoft.com/azurelinux/base/core:3.0 as venv

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

RUN tdnf install --refresh -y \
    build-essential \
    ca-certificates-microsoft \
    gcc \
    iputils \
    python3 \
    python3-devel \
    python3-pip

RUN python3 -m venv /venv && \
        source /venv/bin/activate && \
        pip download --no-deps --index-url $HELIX_FEED helix-scripts && \
        pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl && \
        rm ./helix_scripts-*-py3-none-any.whl

FROM mcr.microsoft.com/azurelinux/base/core:3.0

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

# Install .NET and test dependencies
RUN tdnf update -y && \
    tdnf install --setopt tsflags=nodocs --refresh -y \
        ca-certificates-microsoft \
        icu \
        iputils \
        libgcc-atomic \
        libmsquic \
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
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
