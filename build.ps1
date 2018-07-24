[cmdletbinding()]
param(
    [string]$DockerfilePath = "*",
    [string]$ImageBuilderCustomArgs,
    [switch]$CleanupDocker,

    # Adds "--privileged" to the "docker run" command. In unknown circumstances we encounter on the
    # RHEL build agent, the container must be run with --privileged in order to access the shared
    # docker socket. See https://stackoverflow.com/a/36614457 for an untried potential alternative.
    [switch]$RunPrivileged
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-CleanupDocker()
{
    if ($CleanupDocker) {
        docker system prune -a -f
    }
}

Invoke-CleanupDocker

try {
    & docker build -t imagebuilder --pull -f ./Dockerfile.linux.imagebuilder .
    if ($LastExitCode -ne 0) {
        throw "Failed building ImageBuilder."
    }

    $runPrivilegedArg = ""
    if ($RunPrivileged) {
        $runPrivilegedArg = "--privileged "
    }

    $expression = "docker run --rm " +
        $runPrivilegedArg +
        "-v /var/run/docker.sock:/var/run/docker.sock " +
        "imagebuilder " +
        "build --manifest manifest.json --path '$DockerfilePath' $ImageBuilderCustomArgs"

    Invoke-Expression $expression

    if ($LastExitCode -ne 0) {
        throw "Failed executing ImageBuilder."
    }
}
finally {
    Invoke-CleanupDocker
}
