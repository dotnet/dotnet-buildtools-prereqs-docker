#!/usr/bin/env sh

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u

os=$1
crossToolset=$2
archArg=${3:-}
lldb=${4:-}
rootfsBinDirArg=${5:-}
bypassArchDirArg=${6:-}
llvm=${7:-}

dockerCrossDepsTag="${DOCKER_REPO:-mcr.microsoft.com/dotnet-buildtools/prereqs}:${os}-crossdeps"

# If argument three was set, use that as the arch, otherwise use default arch : 'arm'
arch=${archArg:-'arm'}

# If argument five was set, use that as the rootfsBinDir, otherwise use default : '/rootfs/$arch/bin'
rootfsBinDir="${rootfsBinDirArg:-"/rootfs/$arch/bin"}"

if [ -z "${bypassArchDirArg}" ]; then
    rootfsBaseDir="/rootfs"
else
    rootfsBaseDir="/rootfs/${arch}"
fi

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
docker exec $buildRootFSContainer sh -c '
    git config --global user.email builder@dotnet-buildtools-prereqs-docker &&
    git clone --depth 1 --single-branch https://github.com/dotnet/arcade /scripts'

if [ $? -ne 0 ]; then
    echo "Rootfs build failed: `git clone https://github.com/dotnet/arcade /scripts` returned error"
    docker rm -f $buildRootFSContainer
    exit 1
fi

echo "Running build-rootfs.sh"
docker exec -e ROOTFS_DIR=/rootfs/$arch $buildRootFSContainer \
        /scripts/eng/common/cross/build-rootfs.sh $arch $crossToolset $lldb $llvm --skipunmount

if [ $? -ne 0 ]; then
    echo "Rootfs build failed: build-rootfs.sh returned error"
    docker rm -f $buildRootFSContainer
    exit 1
fi

echo "Checking existence of $rootfsBinDir"
docker exec $buildRootFSContainer \
    [ -d "$rootfsBinDir" ]

if [ $? -ne 0 ]; then
    echo "Rootfs build failed: $rootfsBinDir empty"
    docker rm -f $buildRootFSContainer
    exit 1
fi

echo "Cleaning apt files"
docker exec $buildRootFSContainer \
    bash -c 'rm -rf /rootfs/*/{var/cache/apt/archives/*,var/lib/apt/lists/*,usr/share/doc,usr/share/man}'

echo "Tarring rootfs"
docker exec $buildRootFSContainer \
    tar Ccf ${rootfsBaseDir} - . > $PWD/rootfs.$arch.tar

if [ $? -ne 0 ]; then
    echo "Rootfs build failed: 'tar Ccf ${rootfsBaseDir} - .' returned error"
    docker rm -f $buildRootFSContainer
    exit 1
fi

echo "Shutting down container"
docker rm -f $buildRootFSContainer
