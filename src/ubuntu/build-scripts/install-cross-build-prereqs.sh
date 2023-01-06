#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

# we need to make sure that we install binfmt >= 2.2.0 and qemu-user-static >= 1.4.2,
# which are available in Ubuntu 20.04+ repositories
. /etc/os-release
if [ "$(echo "$VERSION_ID" | tr -d .)" -lt 2004 ]; then
    sed "s/$UBUNTU_CODENAME/focal/g" /etc/apt/sources.list | sudo dd of=/etc/apt/sources.list.d/focal.list
fi

function installPkgs {
    sudo apt-get update
    # see (see https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/120)
    sudo apt-get install -y \
        binfmt-support \
        qemu \
        qemu-user-static
}

# Retry apt-get update due to https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/758
retryCount=0
waitSecs=0
until installPkgs; do
    retryCount=$((retryCount+1))
    if [ $retryCount -lt 5 ]; then
        echo "Failed to update apt-get, retrying in $waitSecs seconds..."
        sleep $waitSecs
    else
        echo "Failed to update apt-get, aborting."
        exit 1
    fi
done
