#!/bin/bash
# This script is called by Renovate's postUpgradeTasks to update LLVM checksums
# in Dockerfiles after a version bump.

set -euo pipefail

if ; then

# Find all Dockerfiles that contain LLVM_VERSION
grep -rl 'LLVM_VERSION=' --include='Dockerfile' src/ | while read -r dockerfile; do
    # Extract the LLVM version from the file
    version=$(grep -oP 'LLVM_VERSION=\K\d+\.\d+\.\d+' "$dockerfile" | head -1)
    if [ -z "$version" ]; then
        continue
    fi

    base_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}"

    # Check if this file has checksum lines to update
    if ! grep -q 'sha256sum -c' "$dockerfile"; then
        continue
    fi

    echo "Updating checksums in $dockerfile for LLVM $version"

    # Download and compute checksum for the .sig file
    sig_checksum=$(curl -sL "${base_url}/llvm-project-${version}.src.tar.xz.sig" | sha256sum | cut -d ' ' -f 1)
    # Download and compute checksum for the .tar.xz file
    tar_checksum=$(curl -sL "${base_url}/llvm-project-${version}.src.tar.xz" | sha256sum | cut -d ' ' -f 1)

    echo "  sig checksum: $sig_checksum"
    echo "  tar checksum: $tar_checksum"

    # Replace the sig checksum (the line echoing the checksum for llvm-project.src.tar.xz.sig)
    sed -i -E "s|echo \"[0-9a-f]{64} llvm-project.src.tar.xz.sig\"|echo \"${sig_checksum} llvm-project.src.tar.xz.sig\"|" "$dockerfile"

    # Replace the tar checksum (the line echoing the checksum for llvm-project.src.tar.xz")
    sed -i -E "s|echo \"[0-9a-f]{64} llvm-project.src.tar.xz\"|echo \"${tar_checksum} llvm-project.src.tar.xz\"|" "$dockerfile"
done
