FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-amd64

RUN apt-get update \
    && apt-get install -y \
        libdbus-glib-1-2 \
        libgtk-3-0 \
        libasound2 \
        libx11-xcb-dev \
    && rm -rf /var/lib/apt/lists/*