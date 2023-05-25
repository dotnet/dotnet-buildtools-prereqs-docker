FROM mcr.microsoft.com/openjdk/jdk:8-mariner

# Dependencies for Android build
RUN tdnf update -y \
    && tdnf install -y \
        # Common dependencies
        ca-certificates \
        binutils \
        cmake \
        clang \
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
        unzip

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r23c-linux.zip \
    && unzip android-ndk-r23c-linux.zip -d /usr/local \
    && mv /usr/local/android-ndk-r23c /usr/local/android-ndk \
    && rm -f android-ndk-r23c-linux.zip

ENV ANDROID_NDK_ROOT=/usr/local/android-ndk

# Grab the necessary Android SDK packages / tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip \
    && mkdir -p /usr/local/android-sdk/cmdline-tools \
    && unzip commandlinetools-linux-8092744_latest.zip -d /usr/local/android-sdk/cmdline-tools \
    && rm -f commandlinetools-linux-8092744_latest.zip

ENV ANDROID_SDK_ROOT=/usr/local/android-sdk

RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses
RUN $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin/sdkmanager --install "build-tools;33.0.0" "platforms;android-33"
