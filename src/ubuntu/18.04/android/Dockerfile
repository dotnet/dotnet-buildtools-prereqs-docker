FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-coredeps

# Dependencies for Android build
RUN apt-get update \
    && apt-get install -y \
        locales \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.tar.gz \
    && tar -xf cmake-3.17.0-Linux-x86_64.tar.gz --strip 1 -C /usr/local \
    && rm cmake-3.17.0-Linux-x86_64.tar.gz

# Android build needs working UTF-8 locale
RUN locale-gen en_US.UTF-8

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip \
    && unzip android-ndk-r21-linux-x86_64.zip -d /usr/local \
    && mv /usr/local/android-ndk-r21 /usr/local/ndk \
    && rm -f android-ndk-r21-linux-x86_64.zip
