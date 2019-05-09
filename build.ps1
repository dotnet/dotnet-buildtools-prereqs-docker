[cmdletbinding()]
param(
    [string]$DockerfilePath = "*",
    [string]$ImageBuilderCustomArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
pushd $PSScriptRoot
try {
    ./scripts/Invoke-ImageBuilder.ps1 "build --path '$DockerfilePath' $ImageBuilderCustomArgs"
}
finally {
    popd
}
