[cmdletbinding()]
param(
     # Additional args to pass to dotnet test
    [string]$OptionalTestArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Log {
    param ([string] $Message)

    Write-Output $Message
}

function Exec {
    param ([string] $Cmd)

    Log "Executing: '$Cmd'"
    Invoke-Expression $Cmd
    if ($LASTEXITCODE -ne 0) {
        throw "Failed: '$Cmd'"
    }
}

$EngCommonDir = "$PSScriptRoot/eng/common"

$DotnetInstallDir = "$PSScriptRoot/.dotnet"
& $EngCommonDir/Install-DotNetSdk.ps1 -InstallPath $DotnetInstallDir

Push-Location "$PSScriptRoot\tests\Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests"
try {
    Exec "$DotnetInstallDir/dotnet test $OptionalTestArgs --results-directory $PSScriptRoot/artifacts/TestResults"
}
finally {
    Pop-Location
}
