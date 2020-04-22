FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-coredeps

# Dependencies for Android build
RUN apt-get update \
    && apt-get install -y \
        locales \
        wget \
        unzip \
        openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.17.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.17.0-Linux-x86_64.tar.gz

# Android build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r21b-linux-x86_64.zip \
    && unzip android-ndk-r21b-linux-x86_64.zip -d /usr/local \
    && mv /usr/local/android-ndk-r21b /usr/local/android-ndk \
    && rm -f android-ndk-r21b-linux-x86_64.zip

ENV ANDROID_NDK_ROOT /usr/local/android-ndk

# Grab the necessary Android SDK packages / tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip \
    && mkdir -p /usr/local/android-sdk/cmdline-tools \
    && unzip commandlinetools-linux-6200805_latest.zip -d /usr/local/android-sdk/cmdline-tools \
    && rm -f commandlinetools-linux-6200805_latest.zip

ENV ANDROID_SDK_ROOT /usr/local/android-sdk

RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --licenses
RUN $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --install "build-tools;29.0.3" "platforms;android-29"
