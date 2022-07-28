FROM arm64v8/ubuntu:18.04

# Install Mono build dependencies
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        autoconf \
        automake \
        bc \
        build-essential \
        cmake \
        curl \
        gcc \
        gdb \
        gettext \
        git \
        iputils-ping \
        jq \
        libgdiplus \
        libtool \
        locales \
        locales-all \
        python3 \
        sudo \
        tzdata \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# create monobot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm monobot && \
    chmod 755 /root && \
    echo "monobot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER monobot
