# Prereq container image lifecycle

The container images in this repository are provided for building .NET source and testing the resultant binaries. The images are built with OS base images and must be updated per the OS lifecycle. This document describes the required patterns.

The images are a mix of Microsoft- and community-supported images.

## Microsoft build images

The build images are built with Azure Linux, supporting both `glibc` and `musl` build flavors. They are built for x64 only, per [Linux build methodology](https://github.com/dotnet/runtime/blob/main/docs/project/linux-build-methodology.md). Microsoft designates the set of images it used for its official build per [The Official Runtime Docker Images](https://github.com/dotnet/runtime/blob/main/docs/workflow/using-docker.md#the-official-runtime-docker-images).

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

Two types of tag styles are available:
* version-specific: The tag name includes the distro's version. Example: `alpine-3.21-helix-amd64`
* floating (optional): The tag name has no version. Instead it is routinely updated to reference a new version as the distro's lifecycle progresses. There are two sub-types of floating tags:
  * latest: References the latest validated version of the distro. Example: `alpine-latest-helix-amd64`
  * oldest: References the oldest supported version of the distro. Example: `alpine-oldest-helix-amd64`

FLoating tags are provided on an as-needed basis. They are beneficial for repos that are not susceptible to breaking changes that occur from new distro versions because the source that references the tag doesn't need to be updated in order to make use of the new version.
Conversely, some repos may be susceptible to distro breaking changes in which case the version-specific tags should be used ([dotnet/runtime](https://github.com/dotnet/runtime) is an example of such a repo).

There is an evaluation period before a `latest` floating tag gets moved to a newer distro version.
First, version-specific tags for the new distro version are provided.
After a one month evaluation period, the `latest` floating tag is updated to reference the new version, assuming there are no issues found.

At times, it may be necessary to use a [fixed image reference](https://github.com/dotnet/runtime/pull/110199#discussion_r1859075989) for build reliability.
This is done by referencing the digest of the specific image that is needed (e.g. `mcr.microsoft.com/dotnet-buildtools/prereqs@sha256:56feee03d202e008a98f3c92784f79f3f0b3a512074f7f8ee2b1ba4ca4c08c6e`).
If this is ever done, a tracking issue should be created (before the PR is merged) so that we remember to resolve the underlying issue and update the image reference.

The following locations are examples of infra that gets updated when new images are available.

- [dotnet/arcade](https://github.com/dotnet/arcade/tree/main/eng/common/templates-official/)
- [dotnet/aspnetcore](https://github.com/dotnet/aspnetcore/tree/main/.azure/pipelines)
- [dotnet/runtime (libraries)](https://github.com/dotnet/runtime/blob/main/eng/pipelines/libraries/helix-queues-setup.yml)
- [dotnet/runtime (coreclr)](https://github.com/dotnet/runtime/blob/main/eng/pipelines/coreclr/templates/helix-queues-setup.yml)

## Community images

Community images are constructed per the needs of the given community.
