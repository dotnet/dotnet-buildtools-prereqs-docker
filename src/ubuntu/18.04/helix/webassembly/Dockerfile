FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y \
        libssl1.0-dev \
        libdbus-glib-1-2 \
        libgtk-3-0 \
        libasound2 \
        libx11-xcb-dev \
        locales \
        nodejs-dev \
        node-gyp \
        npm \
        wget \
        unzip \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN pip3 install --upgrade pip

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env