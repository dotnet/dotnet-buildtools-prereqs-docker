FROM ubuntu.azurecr.io/ubuntu:noble AS venv
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        cargo \
        pkg-config \
        libffi-dev \
        coreutils \
        python3-dev \
        python3-pip \
        python3-venv \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl

FROM ubuntu.azurecr.io/ubuntu:noble
ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qq -y \
        android-sdk \
        autoconf \
        automake \
        build-essential \
        cmake \
        clang \
        curl \
        gcc \
        gdb \
        git \
        gss-ntlmssp \
        iputils-ping \
        libnuma1 \
        libtool \
        libunwind8 \
        lldb \
        llvm \
        locales \
        locales-all \
        openjdk-17-jre \
        python3-dev \
        python3-pip \
        python3-venv \
        qemu-kvm \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN curl "https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/android-sdk/commandlinetools-linux-13114758_latest.zip" -o /tmp/commandlinetools.zip && \
    mkdir -p /usr/local/android-sdk/cmdline-tools /home/helixbot/.android/avd/android_emu_86_64.avd && \
    unzip  /tmp/commandlinetools.zip -d /usr/local/android-sdk/cmdline-tools && \
    yes | /usr/local/android-sdk/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses && \
    /usr/local/android-sdk/cmdline-tools/cmdline-tools/bin/sdkmanager \
       --verbose \
       "system-images;android-31;default;x86_64" \
       "platforms;android-31" \
       "platform-tools" \
       "emulator" && \
    echo no | /usr/local/android-sdk/cmdline-tools/cmdline-tools/bin/avdmanager \
       --verbose \
       create avd \
       --force \
       --name android_emu_86_64 \
       --package 'system-images;android-31;default;x86_64' && \
    /usr/local/android-sdk/emulator/mksdcard -l "sdcard64" "3072M" /home/helixbot/.android/avd/android_emu_86_64.avd/sdcard.img


# Remove user (probably ubuntu) with UID 1000 to UID 2000 to avoid conflict with helixbot
RUN user_id=$(id -un 1000) && \
    /usr/sbin/userdel --force --remove $user_id

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    groupadd -f kvm && \
    usermod -a -G kvm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

