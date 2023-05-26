FROM mcr.microsoft.com/openjdk/jdk:8-mariner

# Dependencies for Android build
RUN tdnf update -y \
    && tdnf install -y \
        # Common dependencies
        ca-certificates \
        binutils \
        cmake \
        clang16 \
        diffutils \
        git \
        tar \
        util-linux \
        wget \
        # Crosscomponents build dependencies
        glibc-devel \
        kernel-headers \
        # Runtime dependencies
        icu \
        # Android dependencies
        zip \
        unzip

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r23c-linux.zip \
    && echo "e5053c126a47e84726d9f7173a04686a71f9a67a android-ndk-r23c-linux.zip" | sha1sum -c \
    && unzip android-ndk-r23c-linux.zip -d /usr/local \
    && mv /usr/local/android-ndk-r23c /usr/local/android-ndk \
    && rm -f android-ndk-r23c-linux.zip

ENV ANDROID_NDK_ROOT=/usr/local/android-ndk

# Grab the necessary Android SDK packages / tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip \
    && echo "d71f75333d79c9c6ef5c39d3456c6c58c613de30e6a751ea0dbd433e8f8b9cbf commandlinetools-linux-8092744_latest.zip" | sha256sum -c \
    && mkdir -p /usr/local/android-sdk/cmdline-tools \
    && unzip commandlinetools-linux-8092744_latest.zip -d /usr/local/android-sdk/cmdline-tools \
    && rm -f commandlinetools-linux-8092744_latest.zip

ENV ANDROID_SDK_ROOT=/usr/local/android-sdk

RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses
RUN $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager --install "build-tools;33.0.0" "platforms;android-33"
