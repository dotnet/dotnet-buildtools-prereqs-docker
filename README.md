# Dockerfiles for Building and Testing the .NET Product

The Dockerfiles in this repository are used for building and testing the .NET product. They are intended for the use of the .NET engineering team and not supported. Feel free to use or contribute to these Dockerfiles if they are useful to you.

The Dockerfiles establish build and test environments for supported Linux and Windows distributions. Teams reference these images from their build and test pipelines.

The images are provided and removed according to [Prereq container image lifecycle](./lifecycle.md).

For any questions, please feel free to open an [issue](https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues) and mention [@dotnet/dotnet-docker-reviewers](https://github.com/orgs/dotnet/teams/dotnet-docker-reviewers).

## Where are the published images

The images produced from the Dockerfiles in this repository are published to the `mcr.microsoft.com/dotnet-buildtools/prereqs` container repository.

- [Latest tags](https://github.com/dotnet/versions/blob/main/build-info/docker/image-info.dotnet-dotnet-buildtools-prereqs-docker-main.json)
- [Full list of tags](https://mcr.microsoft.com/v2/dotnet-buildtools/prereqs/tags/list)

## How to identify an image

There are two tag formats used by the images from this repository. Most of the images follow the format `mcr.microsoft.com/dotnet-buildtools/prereqs:<os-name>-<os-version>-<variant>-<architecture>`.

- `<os-name>` - Name of the Linux distribution or Windows OS the image is based on
- `<os-version>` - Version of the OS
- `<variant>` - Name describing the specialization purpose of the image.
Often special dependencies are needed for certain parts of the product.
It can be beneficial to separate these dependencies into a separate Dockerfile/image.
- `<architecture>` - Architecture of the OS.

Examples:

- mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.20-amd64
- mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-helix-arm64v8

The cross-compilation images follow the format `mcr.microsoft.com/dotnet-buildtools/prereqs:<os-name>-<os-version>-<variant>-cross-<target>`. These are all implicitly amd64 images.

- `<target>` - Specifies the target for cross-compilation, including the targeted architecture and libc variant (glibc if not specified, or musl).

Examples:

- mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-cross-arm64
- mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-cross-amd64-musl

## How to modify or create a new image

There will be a need for modifying existing Dockerfiles or creating new ones.
For example, when a new Linux distribution/version needs to be supported, a corresponding Dockerfile will need to be created.
The following steps are a guideline for modifying/creating Dockerfiles.

1. Edit Dockerfiles
    - Add/Update the Dockerfile(s)
    - If new Dockerfile(s) were added:
        - Place each Dockerfile in the [appropriate src folder](#source-folder-structure)
        - Update the [manifest](#manifest)
        - Update the [CODEOWNERS](./CODEOWNERS) with the respective team code owner(s) (not individual users) for the Dockerfile(s) and list `@dotnet/dotnet-docker-reviewers` as a secondary owner.
        Team code owners must be assigned to each Dockerfile.
        To learn about the expectations of the code owners, see the [Code Owner Responsibilities](#code-owner-responsibilities).

2. Validate the changes locally by running [build.ps1](./build.ps1).
It is strongly suggested to specify the `-Paths` option to avoid the overhead of building all the images.

    For example, if editing the [Fedora 40 Dockerfile](./src/fedora/40/amd64/Dockerfile), then run the following command to build just that Dockerfile.

    ```powershell
    .\build.ps1 -Paths "*fedora/40/amd64*"
    ```

    It is a good practice to use `--dry-run` option on the first attempt to verify what commands will get run.

    ```powershell
    .\build.ps1 -Paths "*fedora/40/amd64*" -OptionalImageBuilderArgs "--dry-run"
    ```

    Partial paths and wildcards in the `-Paths` option are also supported.  The following example will build all the Fedora Dockerfiles.

    ```powershell
    .\build.ps1 -Paths "*fedora/*"
    ```

    To build a dependency graph when there are dependent images, multiple paths can be specified.

    ```powershell
    .\build.ps1 -Paths "*alpine/3.20/amd64*","*alpine/3.20/withnode/amd64*"
    ```

     Alternatively, wildcards can by utilized to specify everything under a shared directory.
     Using wildcards can sometimes cause extra images to be built outside of the dependency graph which may be undersirable.
     In this case, it is recommended to utilize the multiple `paths` approach.

    ```powershell
    .\build.ps1 -Paths "*alpine/3.20*"
    ```

3. Prepare a PR

## When do images get built

The images from this repository get built and published whenever one of the following occurs:

- The corresponding Dockerfile is modified.
- The base image is updated (a new version of the image referred to by the [`FROM`](https://docs.docker.com/engine/reference/builder/#from) statement).
- According to the schedule defined in the [pipeline yaml](eng/pipelines/dotnet-buildtools-prereqs-all.yml).

## How to identify the image digest

The images from this repo are being [rebuilt continuously](#when-do-images-get-built).
As such, in order to diagnose issues/regressions, it is sometimes necessary to be able to identity the specific image used in CI/Helix test runs.
This is useful when needing to examine a previously working version of the image.
The image tag will always reference the latest image version.
To examine an older image, you'll need to retrieve it via its digest which uniquely identifies that specific version of the image.
To retrieve the digest, identify the logic that pulls the image and inspect the output.
For example, to find the image digest of a containerized AzDO job, look at the output of the `Initialize containers` step.

```bash
...
/usr/bin/docker pull mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-fpm
cbl-mariner-2.0-fpm: Pulling from dotnet-buildtools/prereqs
63567fa8bd47: Pulling fs layer
a0bbb2e1d432: Pulling fs layer
a8b51056c91c: Pulling fs layer
a0bbb2e1d432: Verifying Checksum
a0bbb2e1d432: Download complete
63567fa8bd47: Verifying Checksum
63567fa8bd47: Download complete
63567fa8bd47: Pull complete
a8b51056c91c: Verifying Checksum
a8b51056c91c: Download complete
a0bbb2e1d432: Pull complete
a8b51056c91c: Pull complete
Digest: sha256:4dccac3bd646c9edd1f4645cc52828c8d24d66cfe7d8e8191e3c365d37a1c501
Status: Downloaded newer image for mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-fpm
mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-fpm
...
```

In this case the digest of the `mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-fpm` image at the time of this build run is `sha256:4dccac3bd646c9edd1f4645cc52828c8d24d66cfe7d8e8191e3c365d37a1c501`.
You can pull this image by its digest via `docker pull mcr.microsoft.com/dotnet-buildtools/prereqs@sha256:4dccac3bd646c9edd1f4645cc52828c8d24d66cfe7d8e8191e3c365d37a1c501`.

### How to identity the Dockerfile an image was built from

The Dockerfile that an image was built from can be found given the [image digest](#how-to-identify-the-image-digest).
This is possible by searching [version info](https://github.com/dotnet/versions/blob/main/build-info/docker/image-info.dotnet-dotnet-buildtools-prereqs-docker-main.json) for this repository.

```bash
$ git log -S"mcr.microsoft.com/dotnet-buildtools/prereqs@sha256:4dccac3bd646c9edd1f4645cc52828c8d24d66cfe7d8e8191e3c365d37a1c501" -- .\build-info\docker\image-info.dotnet-dotnet-buildtools-prereqs-docker-main.json
commit 199e0e1206404362c3aac6ba1bef15fa7cc290cc
Author: dotnet-docker-bot <dotnet-docker-bot@microsoft.com>
Date:   Mon Aug 5 21:43:41 2024 +0000

    Merging Docker image info updates from build
```

From this commit of the `image-info.dotnet-dotnet-buildtools-prereqs-docker-main.json`, you can retrieve the Dockerfile's `commitUrl`.

``` json
"platforms": [
  {
    "dockerfile": "src/cbl-mariner/2.0/fpm/amd64/Dockerfile",
    "simpleTags": [
      "cbl-mariner-2.0-fpm",
      "cbl-mariner-2.0-fpm-20240805132320-2525e15"
    ],
    "digest": "mcr.microsoft.com/dotnet-buildtools/prereqs@sha256:4dccac3bd646c9edd1f4645cc52828c8d24d66cfe7d8e8191e3c365d37a1c501",
    "baseImageDigest": "mcr.microsoft.com/cbl-mariner/base/core@sha256:a490e0b0869dc570ae29782c2bc17643aaaad1be102aca83ce0b96e0d0d2d328",
    "osType": "Linux",
    "osVersion": "cbl-mariner2.0",
    "architecture": "amd64",
    "created": "2024-08-05T13:25:28.1215548Z",
    "commitUrl": "https://github.com/dotnet/dotnet-buildtools-prereqs-docker/blob/2525e157e2c2abdd6aab2f0e5b511eb959a2b583/src/cbl-mariner/2.0/fpm/amd64/Dockerfile",
    "layers": [
      "sha256:a8b51056c91ca838379088fa3521b54d111c800dbe9870f2b4ad7ef57a70ce99",
      "sha256:a0bbb2e1d432eb6e6dd939d2108dd21f4ed4ee27bd60c1c7e3d0edc1fc7ca833",
      "sha256:63567fa8bd47def3e649849841c5f3be407237a44d8c9b6019ecb21cb0009348"
    ]
  }
]

```

## Additional Info

### Source Folder Structure

The folder structure used in [src](./src) aligns with the tagging convention - `<os-name>-<os-version>-<variant>-<architecture>` or `<os-name>-<os-version>-<variant>-cross-<target>`.
For example, the Dockerfile used to produce the `mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.20-amd64` image is stored in the [src/alpine/3.20/amd64](./src/alpine/3.20/amd64) folder.
The Dockerfile used to produce the `mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net8.0-cross-arm64` image is stored in the [src/azurelinux/3.0/net8.0/cross/arm64](./src/azurelinux/3.0/net8.0/cross/arm64) folder.

If a Dockerfile is shared across multiple architectures, then the `<architecture>` folder should be omitted.
For example, the [src\alpine\3.20\helix\Dockerfile](./src/alpine/3.20/helix/Dockerfile) is built for all supported architectures (amd64, arm64 and arm) therefore there is no architecture folder in its path.

### Manifest

The [manifest.json](./manifest.json) contains metadata used by the build infrastructure to produce the container images.
The metadata describes which Dockerfiles to build, what tags to produce, where to publish the images, etc.
It is critical that the manifest gets updated appropriately when Dockerfiles are added/removed.
The manifest at the root of the repo represents the global manifest.
It has references to sub-manifests within each of the OS folders (e.g. [src/alpine/manifest.json](./src/alpine/manifest.json)).
When adding or modifying entries for Dockerfiles, those changes should be made to the appropriate OS-specific sub-manifest file.
Each Dockerfile will have an entry that looks like the following.

```json
{
  "platforms": [
    {
      "dockerfile": "src/alpine/3.20/amd64",
      "os": "linux",
      "osVersion": "alpine3.20",
      "tags": {
        "alpine-3.20-amd64": {}
      }
    }
  ]
},
{
  "platforms": [
    {
      "architecture": "arm64",
      "dockerfile": "src/debian/12/helix/arm64v8",
      "os": "linux",
      "osVersion": "bookworm",
      "tags": {
        "debian-12-helix-arm64v8": {}
      },
      "variant": "v8"
    }
  ]
},
```

- `architecture` - Architecture of the image: amd64 (default), arm, arm64
- `dockerfile` - Relative path to the Dockerfile to build
- `os` - OS the image is based on: linux, windows
- `osVersion` - Version of the `os` the image is based on
- `tags` - Collection of tags to create for the image
- `variant` - Architecture variant of the image

> [!Note]
> The position in manifest determines the sequence in which the image will be built.

### Code Owner Responsibilities

- **Code reviews** - Code review all changes made to the owned Dockerfiles.
- **Respond to build breaks** - It is possible for a Dockerfile to regress and cause a build break.
When this occurs, the code owner is responsible for addressing the break.
See [Responding to Build Breaks](#responding-to-build-breaks) for additional details.
- **Address CVEs** - When fixable CVEs are reported that require Dockerfiles changes, the code owner is responsible for mitigating the CVE.
- **Remove EOL distros** - Remove or update Dockerfiles based on EOL distros.

Whenever a Dockerfile change is required:

- An issue will be opened and the CODEOWNER will be mentioned.
- The CODEOWNER is responsible for implementing a fix in a timely fashion.

### Image-Builder

The underlying tool used to build the Dockerfiles is called Image-Builder.
Its source is located at [dotnet/docker-tools](https://github.com/dotnet/docker-tools)

## Repo Maintainer Procedures

### Responding to Build Breaks

When a Dockerfile build break occurs the following steps are to be taken:

1. Create a new issue detailing the break.  @mention the appropriate [CODEOWNER](./CODEOWNERS).
2. If the break is blocking automatic rebuilds or blocking the development/release of new changes (judgement decision),
then remove the Dockerfile from the build by deleting the [manifest entry](#manifest).
Note the build disablement in the build break issue.

## Support

This repo is unsupported.
