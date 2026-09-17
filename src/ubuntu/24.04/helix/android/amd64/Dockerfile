FROM ubuntu.azurecr.io/ubuntu:noble AS venv
ENV DEBIAN_FRONTEND=noninteractive
# Use the approved Azure-hosted Ubuntu mirror (per Network Isolation team guidance).
RUN find /etc/apt -type f \( -name '*.sources' -o -name '*.list' \) -exec sed -i 's|//archive\.ubuntu\.com|//azure.archive.ubuntu.com|g' {} +
ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ARG HELIX_FEED

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
    pip download --no-deps --index-url $HELIX_FEED helix-scripts && \
    pip install --index-url $PIP_INDEX_URL ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl

FROM ubuntu.azurecr.io/ubuntu:noble
ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive
# Use the approved Azure-hosted Ubuntu mirror (per Network Isolation team guidance).
RUN find /etc/apt -type f \( -name '*.sources' -o -name '*.list' \) -exec sed -i 's|//archive\.ubuntu\.com|//azure.archive.ubuntu.com|g' {} +
ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

# The API level this image tests. Each API level gets its own image tag, so a single Helix queue
# can cover every level by selecting the matching image, and each work item gets an isolated
# emulator instead of a machine-wide shared one.
ARG ANDROID_API_LEVEL=29
ARG ANDROID_IMAGE_TARGET=default
ARG ANDROID_ABI=x86_64
ARG ANDROID_AVD_NAME=android_emu

RUN apt-get update && \
    apt-get install -qq -y \
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
        libicu-dev \
        libunwind8 \
        lldb \
        llvm \
        locales \
        locales-all \
        openjdk-17-jre \
        python3-dev \
        python3-pip \
        python3-venv \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

# Remove user (probably ubuntu) with UID 1000 to UID 2000 to avoid conflict with helixbot
RUN user_id=$(id -un 1000) && \
    /usr/sbin/userdel --force --remove $user_id

# Create helixbot and give it passwordless sudo. The emulator needs /dev/kvm, which the Helix client
# passes into the container along with the gid that owns the device on the host. A "kvm" group baked
# into the image cannot grant that access: the gid is allocated dynamically per machine, so it does
# not match the host.
RUN /usr/sbin/adduser --disabled-password --gecos '' --uid 1000 --shell /bin/bash --ingroup adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV ANDROID_HOME=/usr/local/android-sdk
ENV ANDROID_AVD_HOME=/home/helixbot/.android/avd
ENV ANDROID_AVD_NAME=${ANDROID_AVD_NAME}
ENV PATH="/usr/local/android-sdk/platform-tools:/usr/local/android-sdk/emulator:${PATH}"

RUN curl "https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/android-sdk/commandlinetools-linux-13114758_latest.zip" -o /tmp/commandlinetools.zip && \
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    unzip -q /tmp/commandlinetools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    rm /tmp/commandlinetools.zip && \
    yes | $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses > /dev/null && \
    $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager \
       --verbose \
       "system-images;android-${ANDROID_API_LEVEL};${ANDROID_IMAGE_TARGET};${ANDROID_ABI}" \
       "platforms;android-${ANDROID_API_LEVEL}" \
       "platform-tools" \
       "emulator"

RUN mkdir -p $ANDROID_AVD_HOME && chown -R helixbot:adm /home/helixbot

USER helixbot

# The AVD is created as helixbot, after the switch above, so that the emulator (which runs as that
# user) can write to it and to the snapshot directory underneath it.
RUN echo no | $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/avdmanager \
       --verbose \
       create avd \
       --force \
       --name ${ANDROID_AVD_NAME} \
       --package "system-images;android-${ANDROID_API_LEVEL};${ANDROID_IMAGE_TARGET};${ANDROID_ABI}" && \
    $ANDROID_SDK_ROOT/emulator/mksdcard -l "sdcard64" "3072M" \
       "$ANDROID_AVD_HOME/${ANDROID_AVD_NAME}.avd/sdcard.img"

# Install Helix Dependencies
ENV VIRTUAL_ENV=/home/helixbot/.vsts-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY --from=venv --chown=helixbot /venv $VIRTUAL_ENV

# Clear PIP_INDEX_URL since it contains a short-lived token that should not persist in the final image
ENV PIP_INDEX_URL=
