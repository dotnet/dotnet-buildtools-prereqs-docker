#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

os=$1
crossToolset=$2

scriptsVolume="scripts$(date +%s)"
dockerCrossDepsTag="microsoft/dotnet-buildtools-prereqs:${os}-crossdeps"

echo "Using $dockerCrossDepsTag to clone core-setup to fetch scripts used to build cross-toolset"
docker run --rm -v $scriptsVolume:/scripts $dockerCrossDepsTag git clone https://github.com/dotnet/core-setup /scripts

rm -rf $PWD/rootfs
mkdir rootfs

# To support additional architectures for which cross toolset needs to be setup,
# simply add it to crossArchArray below.
crossArchArray=("arm")
for arch in $crossArchArray
do
    echo "Using $dockerCrossDepsTag to set up cross-toolset for $arch for $crossToolset"
    buildRootFSContainer="rootfs-$arch-$crossToolset"
    docker run --privileged --rm --name $buildRootFSContainer -e ROOTFS_DIR=/rootfs/$arch \
        -v $PWD/rootfs:/rootfs -v $scriptsVolume:/scripts \
        $dockerCrossDepsTag /scripts/cross/build-rootfs.sh $arch $crossToolset --skipunmount
done
