FROM library/almalinux:9 AS venv

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        gcc \
        gcc-c++ \
        python3.12 \
        python3.12-devel \
        python3.12-pip

RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade pip setuptools \
    && pip download --no-deps --index-url $HELIX_FEED helix-scripts \
    && pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl \
    && rm ./helix_scripts-*-py3-none-any.whl


FROM library/almalinux:9

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

# Install dependencies
RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf config-manager --add-repo=https://packages.microsoft.com/rhel/9/prod/config.repo \
    && dnf install --setopt tsflags=nodocs -y --allowerasing \
        cpio \
        file \
        libicu \
        libmsquic \
        python3.12 \
        sudo \
    && dnf clean all

ENV LANG=en_US.UTF-8

# create helixbot user and give rights to sudo without password
RUN adduser --uid 1000 --shell /bin/bash --gid adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

# Install Helix Dependencies
RUN python3 -m venv $VIRTUAL_ENV \
    && ${VIRTUAL_ENV}/bin/pip install --upgrade pip setuptools
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV
