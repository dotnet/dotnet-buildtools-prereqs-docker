FROM library/fedora:rawhide AS venv

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        openssl \
        # Use Python 3.14 to build the venv: Fedora rawhide's default Python is
        # 3.15 (beta), for which helix-scripts' native deps (cffi, cryptography) have no wheels.
        python3.14 \
        python3-pip \
        gcc \
        libatomic \
        redhat-rpm-config \
    && dnf clean all

RUN python3.14 -m venv /venv \
    && source /venv/bin/activate \
    && pip download --no-deps --index-url $HELIX_FEED helix-scripts \
    && pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl \
    && rm ./helix_scripts-*-py3-none-any.whl

FROM library/fedora:rawhide

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

# Install MSQuic. Fedora rawhide does not have it in the repositories, so use the Fedora 43 package

RUN dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/fedora/43/prod/config.repo \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        libmsquic

# Install Dependencies

RUN dnf upgrade --refresh -y \
    && dnf install --setopt tsflags=nodocs -y \
        dnf-plugins-core \
    && dnf install --setopt=install_weak_deps=False --setopt tsflags=nodocs -y \
        # Helix dependencies
        python3 \
        python3-pip \
        # Python 3.14 hosts azure-cli (installed via pip below)
        python3.14 \
        # Tools used by build automation
        git \
        jq \
        tar \
        redhat-rpm-config \
        procps \
        zip \
        # Runtime dependencies
        curl \
        icu \
        iputils \
        krb5-libs \
        libatomic \
        libunwind \
        lttng-ust \
        openssl \
        sudo \
    && dnf clean all

ENV \
    # Needed for .NET libraries tests to pass
    LANG=en-US.UTF-8

# Install azure-cli from pip into a dedicated Python 3.14 virtual environment.
# Fedora rawhide's default Python is 3.15 (beta), for which the distro azure-cli
# RPM won't resolve and azure-cli's native deps have no prebuilt wheels. Python
# 3.14 has wheels for those deps, so install there and symlink az.
RUN azureEnv="/usr/local/share/azure-cli-env" \
    && python3.14 -m venv "$azureEnv" \
    && "$azureEnv/bin/python" -m pip install --upgrade pip setuptools \
    && "$azureEnv/bin/python" -m pip install azure-cli \
    && ln -s "$azureEnv/bin/az" /usr/local/bin/az

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot \
    && chmod +s /usr/bin/ping

USER helixbot
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env

# Install Helix Dependencies
RUN python3.14 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
