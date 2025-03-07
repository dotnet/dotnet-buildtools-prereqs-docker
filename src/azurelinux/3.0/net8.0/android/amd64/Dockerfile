ARG ANDROID_SDK_ROOT=/usr/local/android-sdk
ARG ANDROID_NDK_VERSION=27.2.12479018
ARG ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/$ANDROID_NDK_VERSION
FROM mcr.microsoft.com/openjdk/jdk:17-mariner AS android-sdk-download
ARG ANDROID_SDK_ROOT
ARG ANDROID_NDK_VERSION
ARG ANDROID_NDK_ROOT

# Dependencies for Android SDK install
RUN tdnf update -y \
    && tdnf install -y \
        # Android dependencies
        wget \
        zip \
        unzip

# Grab the necessary Android SDK packages / tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && echo "2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258 commandlinetools-linux-11076708_latest.zip" | sha256sum -c \
    && mkdir -p /usr/local/cmdline-tools \
    && unzip commandlinetools-linux-11076708_latest.zip -d /usr/local/cmdline-tools \
    && rm -f commandlinetools-linux-11076708_latest.zip \
    && yes | /usr/local/cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --licenses

RUN yes | /usr/local/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses
RUN /usr/local/cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "build-tools;33.0.0" "platforms;android-33" "ndk;${ANDROID_NDK_VERSION}"

# Remove all components of NDK 27 that are flagged by security scanners
RUN rm -r ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/python3/lib/python3.11/site-packages/

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-crossdeps-llvm-amd64

# Install Microsoft OpenJDK from the Microsoft OpenJDK 17 Mariner image.
ENV LANG=en_US.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/msopenjdk-17
ENV PATH=$JAVA_HOME/bin:$PATH
COPY --from=mcr.microsoft.com/openjdk/jdk:17-mariner $JAVA_HOME $JAVA_HOME
ARG ANDROID_SDK_ROOT
ARG ANDROID_NDK_VERSION
ARG ANDROID_NDK_ROOT


# Dependencies for Android build
RUN tdnf update -y \
    && tdnf install -y \
        # Common dependencies
        binutils \
        # Android dependencies
        zip \
        unzip \
        # linux-bionic build dependencies
        openssl-devel

ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV ANDROID_NDK_ROOT=${ANDROID_NDK_ROOT}

COPY --from=android-sdk-download $ANDROID_SDK_ROOT $ANDROID_SDK_ROOT
