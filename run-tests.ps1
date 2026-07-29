[cmdletbinding()]
param(
     # Additional args to pass to dotnet run
    [string[]]$OptionalArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$env:DOTNET_ROLL_FORWARD = 'Major'

$DotNet = if ($IsWindows) {
    "$PSScriptRoot/eng/common/dotnet.ps1"
} else {
    "$PSScriptRoot/eng/common/dotnet.sh"
}
$DotNetArgs = @(
    'run'
    '--project'
    'Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests.csproj'
    '--report-xunit-trx'
    '--results-directory'
    "$PSScriptRoot/artifacts/TestResults"
)
if ($OptionalArgs) {
    $DotNetArgs += $OptionalArgs
}

Push-Location "$PSScriptRoot/tests/Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests"
try {
    & $DotNet @DotNetArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Failed: dotnet run Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests"
    }
}
finally {
    Pop-Location
}
