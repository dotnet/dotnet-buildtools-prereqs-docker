FROM arm32v7/debian:latest

# Dependencies for downloading and running the installation script of libgpiod
RUN apt-get update \
    && apt-get install -y \
            sudo \
            wget \
    && rm -rf /var/lib/apt/lists/*

# Download libgpiod installation script and run it.
RUN wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/libgpiod.sh -O /home/libgpiod.sh \
    && chmod +x /home/libgpiod.sh \
    && sh /home/libgpiod.sh
