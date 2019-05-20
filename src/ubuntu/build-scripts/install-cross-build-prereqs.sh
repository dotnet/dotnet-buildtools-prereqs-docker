#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

# see (see https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/120)
sudo apt-get update
sudo apt-get install -y \
    binfmt-support \
    qemu \
    qemu-user-static
