#!/bin/bash
# This script is called by Renovate's postUpgradeTasks to update LLVM checksums
# in a Dockerfile after a version bump. Renovate provides the target file and
# new version via a data file (RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE).

set -euo pipefail

if [ -z "${RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE:-}" ]; then
    echo "Error: RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE is not set" >&2
    exit 1
fi

dep_name=$(sed -n '1p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")
dockerfile=$(sed -n '2p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")
version=$(sed -n '3p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")

# Only process LLVM upgrades
if [ "$dep_name" != "llvm/llvm-project" ]; then
    exit 0
fi

if [ -z "$dockerfile" ] || [ -z "$version" ]; then
    echo "Error: Data file must contain package file path and version" >&2
    exit 1
fi

# Check if this file has checksum lines to update
if ! grep -q 'sha256sum -c' "$dockerfile"; then
    echo "No checksum lines found in $dockerfile, skipping"
    exit 0
fi

echo "Updating checksums in $dockerfile for LLVM $version"

base_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}"

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
