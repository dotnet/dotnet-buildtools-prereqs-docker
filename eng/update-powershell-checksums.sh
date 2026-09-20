#!/bin/bash
# This script is called by Renovate's postUpgradeTasks to update the pinned
# PowerShell asset checksums in a Dockerfile after a version bump. Renovate
# provides the target file and new version via a data file
# (RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE).
#
# Every pinned checksum is introduced by a comment naming the asset it covers,
# so one Dockerfile can pin several assets (e.g. x64 and arm64):
#
#   # SHA256 of powershell-${POWERSHELL_VERSION}-linux-x64.tar.gz
#   ENV POWERSHELL_SHA256_X64=<64 hex digits>

set -euo pipefail

if [ -z "${RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE:-}" ]; then
    echo "Error: RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE is not set" >&2
    exit 1
fi

dep_name=$(sed -n '1p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")
dockerfile=$(sed -n '2p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")
version=$(sed -n '3p' "$RENOVATE_POST_UPGRADE_COMMAND_DATA_FILE")

# Only process PowerShell upgrades
if [ "$dep_name" != "PowerShell/PowerShell" ]; then
    exit 0
fi

if [ -z "$dockerfile" ] || [ -z "$version" ]; then
    echo "Error: Data file must contain package file path and version" >&2
    exit 1
fi

# Check if this file has checksum lines to update
if ! grep -q '^# SHA256 of ' "$dockerfile"; then
    echo "No checksum lines found in $dockerfile, skipping"
    exit 0
fi

echo "Updating checksums in $dockerfile for PowerShell $version"

# The release's hashes.sha256 is UTF-16LE with CRLF line endings and lists
# entries as "<sha256> *<asset name>".
hashes=$(curl -sL --fail "https://github.com/PowerShell/PowerShell/releases/download/v${version}/hashes.sha256" \
    | iconv -f UTF-16LE -t UTF-8 | tr -d '\r')

if [ -z "$hashes" ]; then
    echo "Error: could not read hashes.sha256 for PowerShell $version" >&2
    exit 1
fi

# Match the naming comments as fixed strings and rewrite the ENV line that
# follows each one, so the asset names need no regex escaping.
while IFS= read -r match; do
    lineno=${match%%:*}
    asset=${match#*:# SHA256 of }
    resolved=${asset//'${POWERSHELL_VERSION}'/$version}

    checksum=$(printf '%s\n' "$hashes" | awk -v asset="*$resolved" '$2 == asset { print $1 }')
    if [ -z "$checksum" ]; then
        echo "Error: $resolved is not listed in hashes.sha256 for $version" >&2
        exit 1
    fi

    echo "  $resolved: $checksum"
    sed -i -E "$((lineno + 1))s|=[0-9a-fA-F]{64}|=${checksum}|" "$dockerfile"
done < <(grep -n '^# SHA256 of ' "$dockerfile")
