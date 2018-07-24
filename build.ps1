[cmdletbinding()]
param(
    [string]$DockerfilePath = "*",
    [string]$ImageBuilderCustomArgs,
    [string]$RunCustomArgs,
    [switch]$CleanupDocker
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

    $expression = "docker run --rm " +
        "-v /var/run/docker.sock:/var/run/docker.sock " +
        "$RunCustomArgs imagebuilder " +
        "build --manifest manifest.json --path '$DockerfilePath' $ImageBuilderCustomArgs"

    Invoke-Expression $expression

    if ($LastExitCode -ne 0) {
        throw "Failed executing ImageBuilder."
    }
}
finally {
    Invoke-CleanupDocker
}
