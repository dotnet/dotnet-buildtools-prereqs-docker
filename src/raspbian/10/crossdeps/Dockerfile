FROM ubuntu:18.04

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
