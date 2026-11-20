FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net12.0-build-aot-test-amd64

ARG CHROME_FOR_TESTING_VERSION=158.0.8127.36

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        alsa-lib \
        atk \
        at-spi2-atk \
        cairo \
        cups-libs \
        fontconfig \
        google-noto-sans-fonts \
        gtk3 \
        libX11 \
        libXcomposite \
        libXcursor \
        libXdamage \
        libXext \
        libXfixes \
        libXi \
        libXrandr \
        libXtst \
        libdrm \
        libxcb \
        libxkbcommon \
        libxkbcommon-x11 \
        libxshmfence \
        mesa-libgbm \
        nss \
        pango \
        unzip \
    && dnf clean all \
    && mkdir -p /opt/chrome-for-testing \
    && curl -fsSL "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_FOR_TESTING_VERSION}/linux64/chrome-linux64.zip" -o /tmp/chrome.zip \
    && curl -fsSL "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_FOR_TESTING_VERSION}/linux64/chromedriver-linux64.zip" -o /tmp/chromedriver.zip \
    && unzip -q /tmp/chrome.zip -d /opt/chrome-for-testing \
    && unzip -q /tmp/chromedriver.zip -d /opt/chrome-for-testing \
    && rm /tmp/chrome.zip /tmp/chromedriver.zip

ENV TEST_CHROME_BINARY=/opt/chrome-for-testing/chrome-linux64/chrome
ENV CHROMEWEBDRIVER=/opt/chrome-for-testing/chromedriver-linux64
