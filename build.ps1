[cmdletbinding()]
param(
    [string]$DockerfilePath = "*",
    [string]$ImageBuilderCustomArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
pushd $PSScriptRoot
$ImageBuilderCustomArgs = "$ImageBuilderCustomArgs --var UniqueId=$(Get-Date -Format yyyyMMddHHmmss)"
try {
    ./eng/common/Invoke-ImageBuilder.ps1 "build --path '$DockerfilePath' $ImageBuilderCustomArgs"
}
finally {
    popd
}
