ARG ANDROID_SDK_ROOT=/usr/local/android-sdk
ARG ANDROID_NDK_VERSION=23.2.8568313
ARG ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/$ANDROID_NDK_VERSION
FROM mcr.microsoft.com/openjdk/jdk:17-mariner-cm2 AS android-sdk-download
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

# We can't upgrade the NDK version as the runtime repo requires tooling that only exists up to NDK 23
# Remove all components of NDK 23 that are flagged by security scanners
RUN rm -r ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/python3/lib/python3.9/site-packages/ \
    && rm -r ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/clang-tidy

FROM mcr.microsoft.com/openjdk/jdk:17-mariner-cm2
ARG ANDROID_SDK_ROOT
ARG ANDROID_NDK_VERSION
ARG ANDROID_NDK_ROOT

# Dependencies for Android build
RUN tdnf update -y \
    && tdnf install -y \
        # Provides 'su', required by Azure DevOps
        util-linux \
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
        unzip \
        # linux-bionic build dependencies
        openssl-devel \
        # ICU dependencies
        awk

ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV ANDROID_NDK_ROOT=${ANDROID_NDK_ROOT}

COPY --from=android-sdk-download $ANDROID_SDK_ROOT $ANDROID_SDK_ROOT
