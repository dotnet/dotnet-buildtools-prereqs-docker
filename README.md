# Dockerfiles for .NET Core Builds

The Dockerfiles in this repository are used for building the .NET Core product.  As such there are Dockerfiles for the various supported Linux distributions which setup the necessary prerequisites to build the .NET Core product.

## Where are the published images

The images produced from the Dockerfiles are published to the mcr.microsoft.com/dotnet-buildtools/prereqs Docker repository.

  - [Latest tags](https://github.com/dotnet/versions/blob/main/build-info/docker/image-info.dotnet-dotnet-buildtools-prereqs-docker-main.json)
  - [Full list of tags](https://mcr.microsoft.com/v2/dotnet-buildtools/prereqs/tags/list)

## How to identify an image

The tag format used by an image is `mcr.microsoft.com/dotnet-buildtools/prereqs:<linux-distribution-name>-<version>-<variant>-<architecture>-<date-time>-<dockerfile-commit-sha>`

- `<linux-distribution-name>` - name of the Linux distribution the image is based on
- `<version>` - version of the Linux distribution
- `<variant>` - name describing the specialization purpose of the image.  Often special dependencies are needed for certain parts of the product.  It can be beneficial to separate these dependencies into a separate Dockerfile/image.
- `<architecture>` - the docker image architecture (amd64 shall be implied if not specified).
- `<date-time>` - UTC timestamp (`yyyyMMddhhmmss`) of when the image was built
- `<dockerfile-commit-sha>` - Git commit SHA of the folder containing the Dockerfile the image was produced from

## How to modify or create a new image

There will be a need for modifying existing Dockerfiles or creating new ones.  For example, when a new Linux distribution/version needs to be supported, a corresponding Dockerfile will need to be created.  The following steps are a guideline for modifying/creating Dockerfiles.

1. Edit Dockerfiles
    - Add/Update the Dockerfile(s)
    - If new Dockerfile(s) were added, then update the [manifest](#manifest)

2. Validate the changes locally by running [build.ps1](./build.ps1).  It is strongly suggested to specify the `-DockerfilePath` option to avoid the overhead of building all the images.

    For example, if editing the [Fedora 30 Dockerfile](./src/fedora/30/amd64/Dockerfile), then run the following command to build just that Dockerfile.

    ```powershell
    .\build.ps1 -DockerfilePath "*fedora/30/amd64*"
    ```

    It is a good practice to use `--dry-run` option on the first attempt to verify what commands will get run.

    ```powershell
    .\build.ps1 -DockerfilePath "*fedora/30/amd64*" -ImageBuilderCustomArgs "--dry-run"
    ```

    Partial paths and wildcards in the `-DockerfilePath` option are also supported.  The following example will build all the Fedora Dockerfiles.

    ```powershell
    .\build.ps1 -DockerfilePath "*fedora/*"
    ```

3. Prepare a PR

## Additional Info

### Source Folder Structure

The folder structure used in [src](./src) aligns with the tagging convention - `<linux-distribution-name>-<version>-<variant>-<architecture>`.  For example, the Dockerfile used to produce the `mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.9-50f0d02-20191210224540` image is stored in the [src/alpine/3.9/amd64](./src/alpine/3.9/amd64) folder.

### Manifest

The [manifest.json](./manifest.json) contains metadata used by the build infrastructure to produce the Docker images.  The metadata describes which Dockerfiles to build, what tags to produce, and where to publish the images.  It is critical that the manifest gets updated appropriately when Dockerfiles are added/removed.  The manifest at the root of the repo represents the global manifest.  It has references to sub-manifests within each of the OS folders (e.g. [src/alpine/manifest.json](./src/alpine/manifest.json)).  When adding or modifying entries for Dockerfiles, those changes should be made to the appropriate OS-specific sub-manifest file.  Each Dockerfile will have an entry that looks like the following.

```json
{
  "platforms": [
    {
      "dockerfile": "alpine/3.9/amd64",
      "os": "linux",
      "tags": {
        "alpine-3.9-$(System:TimeStamp)-$(System:DockerfileGitCommitSha)": {}
      }
    }
  ]
},
{
  "platforms": [
    {
      "architecture": "arm",
      "dockerfile": "src/debian/9/arm32v7",
      "os": "linux",
      "tags": {
        "debian-9-arm32v7-$(System:TimeStamp)-$(System:DockerfileGitCommitSha)": {}
      },
      "variant": "v7"
    }
  ]
},
```

- `architecture` - architecture of the image (default is amd64) [amd64/arm/arm64]
- `dockerfile` - relative path to the Dockerfile to build
- `os` - (linux/windows) the OS type the Docker image is based on
- `tags` - the collection of tags to create for the image
- `variant` - architecture variant of the image
- `$(System:TimeStamp)` and `$(System:DockerfileGitCommitSha)` - built in variable references that are evaluated at build time and substituted

> **Note:** The position in manifest determines the sequence in which the image will be built.

### Image Dependency

A precondition for building an image is to ensure that the base image specified in the [FROM]((https://docs.docker.com/engine/reference/builder/#from)) statement of the Dockerfile is available either locally or can be pulled from a Docker registry.  Some of the Dockerfiles depend on images produced from other Dockerfiles (e.g. [src/ubuntu/22.04/debpkg](./src/ubuntu/22.04/debpkg)).  In these cases, the `FROM` reference should not include the `<date-time>-<dockerfile-commit-sha>` portion of the tags.  This is referred to as a stable tag as it does not change from build to build.  This pattern is used so that the Dockerfiles do not need constant updating as new versions of the base images are built.  To support this scenario, the manifest entry for the base image must be defined to produce the stable tag.

```json
"platforms": [
    {
        "dockerfile": "ubuntu/22.04",
        "os": "linux",
        "tags": {
            "ubuntu-22.04-$(System:TimeStamp)-$(System:DockerfileGitCommitSha)": {},
            "ubuntu-22.04": {
                "isLocal": true
            }
        }
    }
]
```

### Hooks

In certain cases, it is necessary to run custom logic before and after the Dockerfiles are built.  For example, to build the Dockerfiles that are used for cross-gen builds, the rootfs that gets copied into the Docker image needs to be built on the host OS.  To support these scenarios a `pre-build` or `post-build` bash or PowerShell script can be placed in a `hooks` folder next to the Dockerfile.  The scripts will get invoked by the build process.

**Warning:** It is generally recommended to avoid the need to use hooks whenever possible.

### Image-Builder

The underlying tool used to build the Dockerfiles is called Image-Builder.  Its source is located at [dotnet/docker-tools](https://github.com/dotnet/docker-tools)

----------

For any questions, please contact dotnetdocker@microsoft.com
