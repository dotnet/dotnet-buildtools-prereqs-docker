#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

os=$1
crossToolset=$2
archArg=${3:-}
lldb=${4:-}

dockerCrossDepsTag="${DOCKER_REPO:-mcr.microsoft.com/dotnet-buildtools/prereqs}:${os}-crossdeps"

# If argument three was set, use that as the only arch, otherwise use default list of arches : 'arm'
crossArchArray=(${archArg:-'arm'})
for arch in $crossArchArray
do
    rm -rf $PWD/rootfs.$arch.tar

    echo "Using $dockerCrossDepsTag to set up cross-toolset for $arch for $crossToolset"
    buildRootFSContainer="rootfs-$arch-$crossToolset-$(date +%s)"

    # Start a detached container running bash
    docker run --privileged -itd --name $buildRootFSContainer $dockerCrossDepsTag \
        bash

    if [ $? -ne 0 ]; then
        echo "Rootfs build failed: detached container failed to start"
        exit 1
    fi

    echo "Using $dockerCrossDepsTag to clone arcade to fetch scripts used to build cross-toolset"
    docker exec $buildRootFSContainer \
        git clone --depth 1 https://github.com/dotnet/arcade /scripts

    if [ $? -ne 0 ]; then
        echo "Rootfs build failed: `git clone https://github.com/dotnet/arcade /scripts` returned error"
        docker rm -f $buildRootFSContainer
        exit 1
    fi

    echo "Running build-rootfs.sh"
    docker exec -e ROOTFS_DIR=/rootfs/$arch $buildRootFSContainer \
         /scripts/eng/common/cross/build-rootfs.sh $arch $crossToolset $lldb --skipunmount

    if [ $? -ne 0 ]; then
        echo "Rootfs build failed: build-rootfs.sh returned error"
        docker rm -f $buildRootFSContainer
        exit 1
    fi

    echo "Checking existence of /rootfs/$arch/bin"
    docker exec $buildRootFSContainer \
        [ -d /rootfs/$arch/bin ]

    if [ $? -ne 0 ]; then
        echo "Rootfs build failed: rootfs/$arch/bin empty"
        docker rm -f $buildRootFSContainer
        exit 1
    fi

    echo "Cleaning apt files"
    docker exec $buildRootFSContainer \
        rm -rf /rootfs/*/var/cache/apt/archives/* /rootfs/*/var/lib/apt/lists/*

    echo "Tarring rootfs"
    docker exec $buildRootFSContainer \
        tar Ccf /rootfs - . > $PWD/rootfs.$arch.tar

    if [ $? -ne 0 ]; then
        echo "Rootfs build failed: 'tar Ccf /rootfs - .' returned error"
        docker rm -f $buildRootFSContainer
        exit 1
    fi

    echo "Shutting down container"
    docker rm -f $buildRootFSContainer
done
