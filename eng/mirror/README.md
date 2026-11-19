# Mirrored assets

Some images download third-party files from the `resource-packages` container
in the `netcorenativeassets` storage account instead of from their original
hosts. This avoids failures from external hosts under network isolation and
keeps image builds reproducible:

```text
https://netcorenativeassets.blob.core.windows.net/resource-packages/external/
```

Each mirrored asset has a script that builds its folder layout locally and a
`SHA256SUMS` manifest committed next to that script. Changes are reviewed as
manifest diffs in a pull request. After merge, someone with write access to the
storage account uploads the reviewed layout with [`upload.sh`](upload.sh).

| Asset | Layout script | Storage prefix | Consumer |
|-------|---------------|----------------|----------|
| FreeBSD base system, `pkg` source and packages | [`freebsd/build-layout.py`](freebsd/build-layout.py) | `external/freebsd` | `build-rootfs.sh --freebsd-repo` |

Assets mirrored before this process (keyrings, V8, the OpenHarmony SDK and
s390x binutils) were uploaded by hand and are tracked in
https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/1831.

## Rules

- Never overwrite or delete a published file. Images that were already
  released must keep rebuilding with the same content. New versions go to new
  paths. `upload.sh` refuses to replace a file whose content differs.
- Every file is listed in the committed `SHA256SUMS`. The layout scripts verify
  upstream checksums or signatures where the upstream source publishes them.
- Layout scripts need no credentials. Anyone can run them, and each run must
  produce the committed manifest unchanged.

## Updating an asset

Run on Linux with Python 3, GNU `tar` with zstd support, `curl` and
`sha256sum`.

1. Update the pinned versions in the layout script, and in the consumer if it
   pins them too.
2. Build the layout into an empty directory. The script rewrites the committed
   `SHA256SUMS`:

   ```bash
   eng/mirror/freebsd/build-layout.py --output /tmp/freebsd-layout
   ```

3. Validate the consumer against the local layout (see the asset sections
   below), then open a pull request with the script and manifest changes.

## Uploading

After the pull request merges, someone with write access to the storage
account runs this from the merged commit. They need the Azure CLI, signed in
(`az login`) with an identity that has *Storage Blob Data Contributor* on the
container.

```bash
eng/mirror/freebsd/build-layout.py --output /tmp/freebsd-layout --manifest /tmp/SHA256SUMS
diff eng/mirror/freebsd/SHA256SUMS /tmp/SHA256SUMS
eng/mirror/upload.sh --source /tmp/freebsd-layout \
    --manifest eng/mirror/freebsd/SHA256SUMS --prefix external/freebsd
```

`upload.sh` checks the local files against the manifest and skips files that
are already published with the same content. It uploads missing files with
`--overwrite false`, then downloads every listed file from the public URL and
verifies its checksum. It is safe to re-run.

Anyone can check the published files without credentials:

```bash
eng/mirror/upload.sh --verify-only \
    --manifest eng/mirror/freebsd/SHA256SUMS --prefix external/freebsd
```

## FreeBSD

The layout is a sparse copy of upstream paths:

```text
releases/<arch>/<machine-arch>/<version>/base.txz         download.freebsd.org/ftp/releases
pkg/FreeBSD:<abi>:<machine-arch>/<release_N>/meta.conf    pkg.freebsd.org
pkg/FreeBSD:<abi>:<machine-arch>/<release_N>/data.pkg
pkg/FreeBSD:<abi>:<machine-arch>/<release_N>/All/Hashed/*.pkg
pkg-src/<pkg-version>.tar.gz                              github.com/freebsd/pkg/archive
```

- `base.txz` is checked against the release's `MANIFEST`.
- Packages come from the frozen `release_N` set published with each point
  release (for example `release_4` for 14.4-RELEASE), not from `quarterly`,
  which changes over time.
- The catalog (`meta.conf`, `data.pkg`) is copied unmodified. At build time
  `pkg` verifies its signature with the fingerprints in `base.txz`, and the
  layout script checks each package against the catalog's SHA256.
- Only the packages `build-rootfs.sh` installs, plus their dependencies, are
  copied.

The pinned versions in `build-layout.py` (`RELEASES`, `ARCHES`, `PACKAGES`,
`PKG_VERSION`) must match `eng/common/cross/build-rootfs.sh`
(`__FreeBSDBase`, `__FreeBSDPkgRepo`, `__FreeBSDPackages`, `__FreeBSDPkg`).
Refresh the mirror when those change, typically when the minimum supported
FreeBSD version moves, about once or twice a year.

To validate a local layout without network access, serve it from inside the
build container:

```bash
docker run --rm --network none \
    -v "$PWD":/src:ro -v /tmp/freebsd-layout:/mirror:ro <builder-image> \
    bash -c 'cd /mirror && (python3 -m http.server 8000 &) && sleep 1 && \
        /src/eng/common/cross/build-rootfs.sh freebsd14 x64 --rootfsdir /rootfs \
            --freebsd-repo http://127.0.0.1:8000'
```

`<builder-image>` is a FreeBSD Dockerfile's builder stage, which installs the
packages needed to build `pkg`.
