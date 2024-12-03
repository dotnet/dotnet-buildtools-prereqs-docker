# Prereq container image lifecycle

The container images in this repository are provided for building .NET source and testing the resultant binaries. The images are built with OS base images and must be updated per the OS lifecycle. This document describes the required patterns.

Container images are produced for each of the supported Linux distros listed in [Supported OS Versions](https://github.com/dotnet/core/blob/main/os-lifecycle-policy.md) files.

## Build images

Examples:

- [dotnet-buildtools-prereqs-docker #1263](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1263)
- [dotnet/runtime #110198](https://github.com/dotnet/runtime/pull/110198)

Build images are exclusively built with Azure Linux, supporting both `glibc` and `musl` build flavors. They are built for x64 only, per [Linux build methodology](https://github.com/dotnet/runtime/blob/main/docs/project/linux-build-methodology.md).

Build images are uniquely created for each new .NET version with the latest Azure Linux available at that time. The image tags include both the given .NET and Azure Linux versions.

The Azure Linux lifecycle is shorter than the .NET LTS lifecycle. It is expected that build images will need to be (initially) created with Azure Linux n and then replaced with Azure Linux n+1 mid-way through the .NET version lifecycle.

Build images are deleted after a .NET version is no longer supported. It is possible that images will  be required for a while after the published EOL date. 

## Test images

Examples:

- [dotnet-buildtools-prereqs-docker #1227](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1227)
- [dotnet-buildtools-prereqs-docker #1260](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/1260)

Test images are provided for each of the supported OS versions. They are built for each supported architecture. They are shared across .NET versions.

Test images should be deleted after:

- The underlying OS is EOL.
- Test images for a new version are available.
- All references to the old OS versions have been replaced by a newer in-support version

Test images should be be built according to established patterns:

- [dotnet-buildtools-prereqs-docker #1147](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1147)
- [dotnet-buildtools-prereqs-docker #1142](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1142)
- [dotnet-buildtools-prereqs-docker #1070](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1070)

## Image references

Build and test images are referenced in repo infra files, across a variety of `main` and `release/*` branches. Updating these references is a multi-step detail-oriented task. It is a pain, but necessary.

We used version specific references in infra to ensure that our CI builds are reliable. Floating tags (for OS versions) would be guaranteed to break our build. We know that since we often see build and test breaks that need addressing in PRs where we update build and test images.

The following locations are examples of infra that gets updated when new images are available.

- https://github.com/dotnet/runtime/blob/main/eng/pipelines/libraries/helix-queues-setup.yml
- https://github.com/dotnet/runtime/blob/main/eng/pipelines/coreclr/templates/helix-queues-setup.yml
- https://github.com/dotnet/arcade/tree/main/eng/common/templates-official/
- https://github.com/dotnet/aspnetcore/tree/main/.azure/pipelines
