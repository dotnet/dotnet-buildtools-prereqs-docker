#!/usr/bin/env sh

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

# we need to make sure that we install binfmt >= 2.2.0 and qemu-user-static >= 1.4.2,
# which are available in Ubuntu 20.04+ repositories
sudo sh -c '(. /etc/os-release && [ "$(echo "$VERSION_ID" | tr -d .)" -lt 2004 ] && sed -i "s/$UBUNTU_CODENAME/focal/g" /etc/apt/sources.list)'

# see (see https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/120)
sudo apt-get update
sudo apt-get install -y \
    binfmt-support \
    qemu \
    qemu-user-static
