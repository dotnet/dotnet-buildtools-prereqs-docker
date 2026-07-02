FROM library/debian:trixie AS venv

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

# Use Azure-hosted Debian mirror (required in network-restricted Azure build environments)
RUN find /etc/apt -maxdepth 2 \( -name "*.list" -o -name "*.sources" \) \
    -exec sed -i 's|http://deb.debian.org/debian|http://debian-archive.trafficmanager.net/debian|g' {} \;

RUN apt-get update \
    && apt-get install -y \
        cargo \
        coreutils \
        libffi-dev \
        libssl-dev \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip download --no-deps --index-url $HELIX_FEED helix-scripts \
    && pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl \
    && rm ./helix_scripts-*-py3-none-any.whl

FROM library/debian:trixie

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG TARGETARCH

# Use Azure-hosted Debian mirror (required in network-restricted Azure build environments)
RUN find /etc/apt -maxdepth 2 \( -name "*.list" -o -name "*.sources" \) \
    -exec sed -i 's|http://deb.debian.org/debian|http://debian-archive.trafficmanager.net/debian|g' {} \;

# Install Helix Dependencies
RUN LIBCURL=libcurl4 \
    && if [ "$TARGETARCH" = "arm" ]; then \
        LIBCURL="libcurl4t64"; fi \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-transport-https \
        curl \
    && curl -sL https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        at \
        build-essential \
        cpio \
        gcc \
        gdb \
        git \
        gpg \
        iputils-ping \
        $LIBCURL \
        libffi-dev \
        libicu-dev \
        libmsquic \
        libssl-dev \
        libtool \
        libunwind8 \
        lldb \
        llvm \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

# Create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot \
    && chmod 755 /root \
    && echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
