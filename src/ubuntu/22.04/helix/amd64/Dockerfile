FROM ubuntu:22.04

# Install Helix Dependencies
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        clang \
        gcc \
        gdb \
        git \
        gss-ntlmssp \
        iputils-ping \
        libcurl4 \
        libffi-dev \
        libgdiplus \
        libicu-dev \
        libssl-dev \
        libtool \
        libunwind8 \
        libunwind-dev \
        lldb-12 \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==22.0.4 && \
    python -m pip install virtualenv==20.14.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# Build MsQuic as we don't have binary package.
# Ubuntu 22  does not have OpenSSL 1.1.1 package and MsQuic releases currently do not work with OpenSSL 3.
# Support for OpenSSL 3 is early progress in msquic/main.
RUN apt-get update && \
    apt-get install -qq -y \
        liblttng-ust-dev \
        ruby-dev && \
    gem install fpm && \
    cd /tmp && \
    git clone --depth 1 --single-branch --branch main --recursive https://github.com/dotnet/msquic && \
    cd msquic/src/msquic && \
    cmake -B build/linux/x64_openssl3 \
        -DQUIC_OUTPUT_DIR=/tmp/msquic/src/msquic/artifacts/bin/linux/x64_Release_openssl3 \
        -DCMAKE_BUILD_TYPE=Release \
        -DQUIC_TLS=openssl3 \
        -DQUIC_ENABLE_LOGGING=true \
        -DQUIC_USE_SYSTEM_LIBCRYPTO=true \
        -DQUIC_BUILD_TOOLS=off \
        -DQUIC_BUILD_TEST=off \
        -DQUIC_BUILD_PERF=off && \
     cmake --build build/linux/x64_openssl3  --config Release && \
     ./scripts/make-packages.sh --tls openssl3 --config Release && \
     dpkg -i artifacts/packages/linux/x64_Release_openssl3/libmsquic_*.deb && \
     rm -rf /tmp/msquic && \
     apt-get remove -y \
        liblttng-ust-dev \
        ruby-dev && \
     apt autoremove -y && \
     rm -rf /var/lib/apt/lists/*

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv /home/helixbot/.vsts-env
