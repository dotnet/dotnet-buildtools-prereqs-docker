FROM ubuntu.azurecr.io/ubuntu:18.04

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        debootstrap \
        git \
        qemu \
        qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

# Install raspbian package signing keys
RUN wget http://raspbian.raspberrypi.org/raspbian/pool/main/r/raspbian-archive-keyring/raspbian-archive-keyring_20120528.2.tar.gz && \
    echo "b3f22fa8d63d8d2f8b81f77784c3dc8f65fd6a10eadda63ac30a2da483ffc9d6ac72d0b5d3d0d5bdf2a61ca264a26fa071aed3acc780f062c8ab27a2e5ac6d49 raspbian-archive-keyring_20120528.2.tar.gz" | sha512sum -c && \
    tar xf raspbian-archive-keyring_20120528.2.tar.gz && \
    mv raspbian-archive-keyring-20120528.2/keyrings/raspbian-archive-keyring.gpg /usr/share/keyrings/ && \
    rm -r raspbian-archive-keyring_20120528.2.tar.gz raspbian-archive-keyring-20120528.2
