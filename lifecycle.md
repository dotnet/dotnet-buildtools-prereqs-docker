# Prereq container image lifecycle

The container images in this repository are provided for building .NET source and testing the resultant binaries. The images are built with OS base images and must be updated per the OS lifecycle. This document describes the required patterns.

The images are a mix of Microsoft- and community-supported images.

## Microsoft build images

The build images are primarily built with Azure Linux, supporting both `glibc` and `musl` build flavors. They are built for x64 only, per [Linux build methodology](https://github.com/dotnet/runtime/blob/main/docs/project/linux-build-methodology.md). Microsoft designates the set of images it used for its official build per [The Official Runtime Docker Images](https://github.com/dotnet/runtime/blob/main/docs/workflow/using-docker.md#the-official-runtime-docker-images).

Build images are uniquely created for each new .NET version with the latest Azure Linux available at that time. The image tags include both the given .NET and Azure Linux versions. The tag may also contain a target OS and architecture.

The Azure Linux lifecycle is shorter than the .NET LTS lifecycle. It is expected that build images will need to be (initially) created with Azure Linux n and then replaced with Azure Linux n+1 mid-way through the .NET version lifecycle. They may also need to be updated if the target OS is EOL.

Build images are deleted after a .NET version is no longer supported. It is possible that images will be required for a while after the published EOL date.

Examples:

- [dotnet-buildtools-prereqs-docker #1263](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1263)
- [dotnet/runtime #110198](https://github.com/dotnet/runtime/pull/110198)

## Microsoft test images

Test images are produced for the supported Linux distros listed in [Supported OS Versions](https://github.com/dotnet/core/blob/main/os-lifecycle-policy.md) files. In some cases, a [compatible derivative](https://github.com/dotnet/core/blob/main/support.md#compatible-derivatives) will be used. Images are built for a variety of architectures based on need. They are shared across .NET versions.

Test images should be deleted after:

- The underlying OS is EOL.
- Test images for a new version are available.
- All references to the old OS versions have been replaced by a newer in-support version

Examples:

- [dotnet-buildtools-prereqs-docker #1227](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1227)
- [dotnet-buildtools-prereqs-docker #1260](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/1260)

### Test image construction

Test images should be be built according to established patterns:

- [dotnet-buildtools-prereqs-docker #1147](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1147)
- [dotnet-buildtools-prereqs-docker #1142](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1142)
- [dotnet-buildtools-prereqs-docker #1070](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/pull/1070)

Note: this content should be moved to another location as it is not lifecycle related.

## Image references

Build and test images are referenced in repo infra files, across a variety of `main` and `release/*` branches. Updating these references is a multi-step detail-oriented task. It is a pain, but necessary.

We use version specific references in infra to ensure that our CI builds are reliable. One can imagine using floating OS tags (such as `debian-oldest` and `debian-latest`), however such an approach would be guaranteed to break our build. We know that since we often see build and test breaks that need addressing in PRs where we update build and test images.

At times, it may be necessary to use a [fixed image reference](https://github.com/dotnet/runtime/pull/110199#discussion_r1859075989) for build reliability. If this is ever done, a tracking issue should be created (before the PR is merged) so that we remember to resolve the underlying issue and update the image reference.

The following locations are examples of infra that gets updated when new images are available.

- [dotnet/arcade](https://github.com/dotnet/arcade/tree/main/eng/common/templates-official/)
- [dotnet/aspnetcore](https://github.com/dotnet/aspnetcore/tree/main/.azure/pipelines)
- [dotnet/runtime (libraries)](https://github.com/dotnet/runtime/blob/main/eng/pipelines/libraries/helix-queues-setup.yml)
- [dotnet/runtime (coreclr)](https://github.com/dotnet/runtime/blob/main/eng/pipelines/coreclr/templates/helix-queues-setup.yml)

## Community images

Community images are constructed per the needs of the given community.
