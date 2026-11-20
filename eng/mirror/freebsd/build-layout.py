#!/usr/bin/env python3
"""Produce the FreeBSD mirror layout consumed by `build-rootfs.sh --freebsd-repo`.

The output is a sparse copy of the upstream FreeBSD layout:

    releases/<arch>/<machine-arch>/<version>/base.txz
    pkg/FreeBSD:<abi>:<machine-arch>/<pkg-repo>/{meta.conf,data.pkg}
    pkg/FreeBSD:<abi>:<machine-arch>/<pkg-repo>/All/Hashed/<package>.pkg
    pkg-src/<pkg-version>.tar.gz

Package catalogs (meta.conf and data.pkg, the files pkg fetches) are copied
unmodified, so pkg still verifies FreeBSD's
signature against the fingerprints shipped in base.txz. Only the requested
packages and their transitive dependencies are copied.

A SHA256SUMS manifest covering every file is written to
eng/mirror/freebsd/SHA256SUMS by default; commit it so the uploaded content is
reviewed. See eng/mirror/README.md for the runbook.
"""

import argparse
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import time
import urllib.request

# Keep in sync with eng/common/cross/build-rootfs.sh.
RELEASES = {
    # abi: (base release, frozen package set)
    "14": ("14.4-RELEASE", "release_4"),
    "15": ("15.1-RELEASE", "release_1"),
}
ARCHES = {
    # build-rootfs arch: (FreeBSD arch, FreeBSD machine arch)
    "x64": ("amd64", "amd64"),
    "arm64": ("arm64", "aarch64"),
}
PACKAGES = ["libunwind", "icu", "libinotify", "openssl", "krb5", "terminfo-db"]
PKG_VERSION = "2.8.0"

BASE_URL = "https://download.freebsd.org/ftp/releases"
PKG_URL = "https://pkg.freebsd.org"
PKG_SRC_URL = "https://github.com/freebsd/pkg/archive"
REPO_METADATA = ["meta.conf", "data.pkg"]


def download(url, dest):
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    for attempt in range(1, 6):
        try:
            with urllib.request.urlopen(url, timeout=60) as response, open(dest + ".part", "wb") as f:
                while chunk := response.read(1 << 20):
                    f.write(chunk)
            os.replace(dest + ".part", dest)
            return
        except OSError as e:
            if attempt == 5 or getattr(e, "code", None) == 404:
                raise RuntimeError(f"failed to download {url}: {e}") from e
            print(f"  retry {attempt} for {url}: {e}", file=sys.stderr)
            time.sleep(2 * attempt)


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while chunk := f.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def fetch_base(out, version, arch, machine_arch):
    rel = f"releases/{arch}/{machine_arch}/{version}"
    print(f"base: {rel}/base.txz")
    with tempfile.TemporaryDirectory() as tmp:
        manifest = os.path.join(tmp, "MANIFEST")
        download(f"{BASE_URL}/{arch}/{machine_arch}/{version}/MANIFEST", manifest)
        expected = None
        with open(manifest) as f:
            for line in f:
                fields = line.split("\t")
                if fields[0] == "base.txz":
                    expected = fields[1]
        if not expected:
            raise RuntimeError(f"base.txz not listed in {rel}/MANIFEST")
    dest = os.path.join(out, rel, "base.txz")
    download(f"{BASE_URL}/{arch}/{machine_arch}/{version}/base.txz", dest)
    actual = sha256(dest)
    if actual != expected:
        raise RuntimeError(f"{rel}/base.txz: SHA256 {actual} does not match MANIFEST {expected}")


def read_catalog(data_pkg):
    with tempfile.TemporaryDirectory() as tmp:
        subprocess.run(["tar", "-xf", data_pkg, "-C", tmp, "data"], check=True)
        with open(os.path.join(tmp, "data")) as f:
            return {entry["name"]: entry for entry in json.load(f)["packages"]}


def resolve(catalog, roots):
    needed, pending = set(), list(roots)
    while pending:
        name = pending.pop()
        if name in needed:
            continue
        if name not in catalog:
            raise RuntimeError(f"package {name} not found in catalog")
        needed.add(name)
        pending.extend(catalog[name].get("deps", {}).keys())
    return sorted(needed)


def fetch_packages(out, abi, machine_arch, pkg_repo, packages):
    upstream = f"FreeBSD:{abi}:{machine_arch}/{pkg_repo}"
    rel = f"pkg/{upstream}"
    print(f"packages: {rel}")
    for name in REPO_METADATA:
        download(f"{PKG_URL}/{upstream}/{name}", os.path.join(out, rel, name))
    catalog = read_catalog(os.path.join(out, rel, "data.pkg"))
    for name in resolve(catalog, packages):
        entry = catalog[name]
        dest = os.path.join(out, rel, entry["repopath"])
        print(f"  {name}-{entry['version']}")
        download(f"{PKG_URL}/{upstream}/{entry['repopath']}", dest)
        actual = sha256(dest)
        if actual != entry["sum"]:
            raise RuntimeError(f"{rel}/{entry['repopath']}: SHA256 {actual} does not match catalog {entry['sum']}")


def write_manifest(out, manifest):
    files = []
    for root, _, names in os.walk(out):
        for name in names:
            files.append(os.path.relpath(os.path.join(root, name), out))
    with open(manifest, "w") as f:
        for rel in sorted(files):
            f.write(f"{sha256(os.path.join(out, rel))}  {rel}\n")
    print(f"wrote {manifest} ({len(files)} files)")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--output", required=True, help="empty directory to write the layout to")
    parser.add_argument("--manifest", help="SHA256SUMS path (default: SHA256SUMS next to this script)")
    parser.add_argument("--abi", action="append", choices=sorted(RELEASES), help="FreeBSD major version (default: all)")
    parser.add_argument("--arch", action="append", choices=sorted(ARCHES), help="architecture (default: all)")
    args = parser.parse_args()

    out = os.path.abspath(args.output)
    if os.path.exists(out) and os.listdir(out):
        parser.error(f"{out} is not empty")
    manifest = os.path.abspath(args.manifest or os.path.join(os.path.dirname(os.path.abspath(__file__)), "SHA256SUMS"))
    if manifest.startswith(out + os.sep):
        parser.error("--manifest must be outside --output")

    download(f"{PKG_SRC_URL}/{PKG_VERSION}.tar.gz", os.path.join(out, "pkg-src", f"{PKG_VERSION}.tar.gz"))
    for abi in args.abi or sorted(RELEASES):
        version, pkg_repo = RELEASES[abi]
        for build_arch in args.arch or sorted(ARCHES):
            arch, machine_arch = ARCHES[build_arch]
            fetch_base(out, version, arch, machine_arch)
            fetch_packages(out, abi, machine_arch, pkg_repo, PACKAGES)
    write_manifest(out, manifest)


if __name__ == "__main__":
    main()
