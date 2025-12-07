[cmdletbinding()]
param(
    # Paths to the Dockerfiles to build
    [string[]]$Paths,

     # Additional args to pass to ImageBuilder
    [string]$OptionalImageBuilderArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
pushd $PSScriptRoot
try {
    ./eng/docker-tools/build.ps1 -Paths $Paths -OptionalImageBuilderArgs $OptionalImageBuilderArgs
}
finally {
    popd
}
