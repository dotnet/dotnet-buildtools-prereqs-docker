#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

os=$1
crossToolset=$2
archArg=${3:-}
lldb=${4:-}

scriptsVolume="scripts$(date +%s)"
dockerCrossDepsTag="microsoft/dotnet-buildtools-prereqs:${os}-crossdeps"

echo "Using $dockerCrossDepsTag to clone core-setup to fetch scripts used to build cross-toolset"
docker run --rm -v $scriptsVolume:/scripts $dockerCrossDepsTag git clone https://github.com/dotnet/core-setup /scripts

rm -rf $PWD/rootfs
mkdir rootfs

# If argument three was set, use that as the only arch, otherwise use default list of arches : 'arm x86'
crossArchArray=(${archArg:-'arm x86'})
for arch in $crossArchArray
do
    echo "Using $dockerCrossDepsTag to set up cross-toolset for $arch for $crossToolset"
    buildRootFSContainer="rootfs-$arch-$crossToolset"
    docker run --privileged --name $buildRootFSContainer -e ROOTFS_DIR=/rootfs/$arch \
        -v $scriptsVolume:/scripts \
        $dockerCrossDepsTag /scripts/cross/build-rootfs.sh $arch $crossToolset $lldb --skipunmount || \
        exit 1
    docker cp $buildRootFSContainer:/rootfs/. $PWD/rootfs/
    chmod -R 777 $PWD/rootfs
    docker rm -f $buildRootFSContainer

    if [[ ! -d $PWD/rootfs/$arch/bin ]]; then
        echo "Rootfs build failed: missing directory rootfs/$arch/bin"
        exit 1
    fi
done
