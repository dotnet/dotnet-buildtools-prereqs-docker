#!/usr/bin/env bash
# Upload a mirror layout to the resource-packages storage and verify it.
# See eng/mirror/README.md for the runbook.

set -euo pipefail

usage()
{
    cat <<EOF
Usage: $0 --source <dir> --manifest <SHA256SUMS> --prefix <path> [--verify-only]

  --source <dir>          Local layout produced by a build-layout script.
  --manifest <file>       SHA256SUMS listing every file, relative to --source
                          (and to --prefix in storage).
  --prefix <path>         Destination path under the container, e.g. external/freebsd.
  --verify-only           Skip uploading; only check the published files.
  --account <name>        Storage account (default: netcorenativeassets).
  --container <name>      Storage container (default: resource-packages).

Files that already exist with the expected content are skipped. Existing files
with different content are never overwritten; the script fails instead.
EOF
    exit 1
}

account=netcorenativeassets
container=resource-packages
source_dir=
manifest=
prefix=
verify_only=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --source) source_dir="$2"; shift 2 ;;
        --manifest) manifest="$2"; shift 2 ;;
        --prefix) prefix="${2%/}"; prefix="${prefix#/}"; shift 2 ;;
        --account) account="$2"; shift 2 ;;
        --container) container="$2"; shift 2 ;;
        --verify-only) verify_only=1; shift ;;
        *) usage ;;
    esac
done

[[ -n "$manifest" && -n "$prefix" ]] || usage
[[ "$verify_only" == 1 || -n "$source_dir" ]] || usage
manifest="$(realpath "$manifest")"
base_url="https://${account}.blob.core.windows.net/${container}/${prefix}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Prints "match", "missing" or "mismatch" for a published file.
remote_state()
{
    local rel="$1" expected="$2" status
    status=$(curl -sS -o "$work/remote" -w '%{http_code}' --retry 5 --retry-all-errors "$base_url/$rel" || true)
    case "$status" in
        200)
            if [[ "$(sha256sum "$work/remote" | cut -d' ' -f1)" == "$expected" ]]; then echo match; else echo mismatch; fi ;;
        404) echo missing ;;
        *) echo "ERROR: HTTP $status for $base_url/$rel" >&2; exit 1 ;;
    esac
}

if [[ "$verify_only" == 0 ]]; then
    echo "Checking local files against $manifest"
    (cd "$source_dir" && sha256sum --quiet -c "$manifest")
    command -v az >/dev/null || { echo "ERROR: Azure CLI (az) is required to upload." >&2; exit 1; }

    while read -r sum rel; do
        state="$(remote_state "$rel" "$sum")" || exit 1
        case "$state" in
            match) echo "exists:   $rel" ;;
            mismatch) echo "ERROR: $base_url/$rel exists with different content; refusing to overwrite." >&2; exit 1 ;;
            missing)
                echo "upload:   $rel"
                az storage blob upload --only-show-errors --auth-mode login --overwrite false \
                    --account-name "$account" --container-name "$container" \
                    --name "$prefix/$rel" --file "$source_dir/$rel" >/dev/null </dev/null ;;
            *) exit 1 ;;
        esac
    done < "$manifest"
fi

echo "Verifying published files at $base_url"
failed=0
while read -r sum rel; do
    state="$(remote_state "$rel" "$sum")" || exit 1
    if [[ "$state" != match ]]; then
        echo "FAILED ($state): $rel" >&2
        failed=1
    fi
done < "$manifest"
[[ "$failed" == 0 ]] || exit 1
echo "All $(wc -l < "$manifest") files verified."
