[cmdletbinding()]
param(
     # Additional args to pass to dotnet run
    [string]$OptionalArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Push-Location "$PSScriptRoot\tests\Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests"
try {
    & "$PSScriptRoot/eng/common/dotnet.ps1" run --project Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests.csproj --report-xunit-trx --results-directory $PSScriptRoot/artifacts/TestResults $OptionalArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Failed: '$Cmd'"
    }
}
finally {
    Pop-Location
}
