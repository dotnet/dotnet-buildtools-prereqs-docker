[cmdletbinding()]
param(
     # Additional args to pass to dotnet run
    [string]$OptionalArgs
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

$EngDockerToolsDir = "$PSScriptRoot/eng/docker-tools"

$DotnetInstallDir = "$PSScriptRoot/.dotnet"
& $EngDockerToolsDir/Install-DotNetSdk.ps1 -InstallPath $DotnetInstallDir

Push-Location "$PSScriptRoot\tests\Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests"
try {
    Exec "$DotnetInstallDir/dotnet run --project Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests.csproj --report-xunit-trx --results-directory $PSScriptRoot/artifacts/TestResults $OptionalArgs"
}
finally {
    Pop-Location
}
