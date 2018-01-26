[cmdletbinding()]
param(
    [string]$DockerfilePath = "*",
    [string]$ImageBuilderCustomArgs,
    [switch]$CleanupDocker
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ExecuteWithRetry($Command) {
    $attempt = 0
    $maxRetries = 5
    $waitFactor = 6
    while ($attempt -lt $maxRetries) {
        try {
            & $Command @args
            break
        }
        catch {
            Write-Warning "$_"
        }

        $attempt++
        if ($attempt -ne $maxRetries) {
            $waitTime = $attempt * $waitFactor
            Write-Host "Retry ${attempt}/${maxRetries} failed, retrying in $waitTime seconds..."
            Start-Sleep -Seconds ($waitTime)
        }
        else {
            throw "Retry ${attempt}/${maxRetries} failed, no more retries left."
        }
    }
}

function Invoke-CleanupDocker()
{
    if ($CleanupDocker) {
        docker system prune -a -f
    }
}

Invoke-CleanupDocker

try {
    ExecuteWithRetry docker pull 'microsoft/dotnet-buildtools-prereqs:image-builder-jessie-20180117125404'

    & docker build -t imagebuilder -f ./Dockerfile.linux.imagebuilder .
    if ($LastExitCode -ne 0) {
        throw "Failed building ImageBuilder."
    }

    & docker run --rm `
        -v /var/run/docker.sock:/var/run/docker.sock `
        imagebuilder `
        build --manifest "manifest.json" --path "$DockerfilePath" "$ImageBuilderCustomArgs"

    if ($LastExitCode -ne 0) {
        throw "Failed executing ImageBuilder."
    }
}
finally {
    Invoke-CleanupDocker
}
